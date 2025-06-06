package com.cs301g2t1.account.controller;

import java.util.Set;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.data.redis.core.StringRedisTemplate;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.cs301g2t1.account.model.Account;
import com.cs301g2t1.account.service.AccountService;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.validation.Valid;


@RestController
@RequestMapping("/accounts")
public class AccountController {
    private final AccountService accountService;

    @Value("${spring.data.redis.host}")
    private String redisHost;

    @Value("${spring.data.redis.port}")
    private int redisPort;

    // Inject the Redis template to interact with ElastiCache (Redis)
    @Autowired
    private StringRedisTemplate redisTemplate;

    @Autowired
    public AccountController(AccountService accountService) {
        this.accountService = accountService;
    }
    
    @PostMapping
    public ResponseEntity<?> createAccount(HttpServletRequest request, @Valid @RequestBody Account account) {
        String agentId = accountService.getAgentId(request);
        // System.out.println("Agent ID: " + agentId);
        if (agentId == null) {
            return ResponseEntity.status(401).body("Unauthorized");
        }
        Account createdAccount = accountService.createAccount(account, agentId);
        return new ResponseEntity<>(createdAccount, HttpStatus.CREATED);
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<?> deleteAccount(HttpServletRequest request, @PathVariable Long id) {
        String agentId = accountService.getAgentId(request);
        // System.out.println("Agent ID: " + agentId);
        if (agentId == null) {
            return ResponseEntity.status(401).body("Unauthorized");
        }
        try {
            Account deletedAccount = accountService.deleteAccount(id, agentId);
            return new ResponseEntity<>(deletedAccount, HttpStatus.OK);
        } catch (IllegalArgumentException ex) {
            return new ResponseEntity<>(null, HttpStatus.NOT_FOUND);
        }
    }

    @PutMapping("/{id}")
    public ResponseEntity<?> updateAccount(HttpServletRequest request, @PathVariable Long id, @Valid @RequestBody Account account) {
        String agentId = accountService.getAgentId(request);
        // System.out.println("Agent ID: " + agentId);
        if (agentId == null) {
            return ResponseEntity.status(401).body("Unauthorized");
        }
        try {
            Account updatedAccount = accountService.updateAccount(id, account, agentId);
            return new ResponseEntity<>(updatedAccount, HttpStatus.OK);
        } catch (IllegalArgumentException ex) {
            return new ResponseEntity<>(null, HttpStatus.NOT_FOUND);
        }
    }

    @GetMapping("/{id}")
    public ResponseEntity<?> getAccountById(@PathVariable Long id) {
        try {
            Account account = accountService.getAccountById(id);
            return new ResponseEntity<>(account, HttpStatus.OK);
        } catch (IllegalArgumentException ex) {
            return new ResponseEntity<>(null, HttpStatus.NOT_FOUND);
        }
    }
    
    @GetMapping("/client/{clientId}")
    public ResponseEntity<?> getAccountsByClientId(@PathVariable Long clientId) {
        try {
            return new ResponseEntity<>(accountService.getAccountsByClientId(clientId), HttpStatus.OK);
        } catch (IllegalArgumentException ex) {
            return new ResponseEntity<>(null, HttpStatus.NOT_FOUND);
        }
    }

    @GetMapping
    public ResponseEntity<?> getAllAccounts(HttpServletRequest request) {
        return new ResponseEntity<>(accountService.getAllAccounts(), HttpStatus.OK);
    }
    

    // New endpoint to test Redis caching (ElastiCache)
    @GetMapping("/cache-test")
    public ResponseEntity<String> testCache() {
        // Print the Redis host and port from application properties
        // String redisHost = env.getProperty("spring.data.redis.host");
        // String redisPort = env.getProperty("spring.data.redis.port");
        System.out.println("Attempting to connect to Redis at host: " + redisHost + " on port: " + redisPort);

        try {
            // Write a test value to Redis
            redisTemplate.opsForValue().set("testKey", "testValue");
            System.out.println("Successfully set key 'testKey' to 'testValue'");
            // Read the test value from Redis
            String value = redisTemplate.opsForValue().get("testKey");
            System.out.println("Retrieved value from Redis: " + value);
            return ResponseEntity.ok("Value from Redis: " + value);
        } catch (Exception e) {
            // Print full stack trace if there's an error connecting to Redis
            e.printStackTrace();
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body("Error connecting to Redis: " + e.getMessage());
        }
    }

    @GetMapping("/cache-keys")
    public Set<String> getAllKeys() {
        return redisTemplate.keys("*");
    }
}
