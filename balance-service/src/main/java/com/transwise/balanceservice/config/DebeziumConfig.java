package com.transwise.balanceservice.config;

import io.debezium.config.Configuration;
import io.debezium.embedded.EmbeddedEngine;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

@Configuration
@Slf4j
public class DebeziumConfig {
    
    @Value("${spring.datasource.url}")
    private String databaseUrl;
    
    @Value("${spring.datasource.username}")
    private String databaseUsername;
    
    @Value("${spring.datasource.password}")
    private String databasePassword;
    
    @Value("${debezium.schema.include.list:cargo}")
    private String schemaIncludeList;
    
    @Value("${debezium.table.include.list:cargo}")
    private String tableIncludeList;
    
    @Bean
    public Configuration debeziumConfig() {
        return Configuration.create()
                .with("name", "cargo-connector")
                .with("connector.class", "io.debezium.connector.postgresql.PostgresConnector")
                .with("database.hostname", extractHostname(databaseUrl))
                .with("database.port", extractPort(databaseUrl))
                .with("database.user", databaseUsername)
                .with("database.password", databasePassword)
                .with("database.dbname", extractDatabaseName(databaseUrl))
                .with("database.server.name", "cargo-server")
                .with("schema.include.list", schemaIncludeList)
                .with("table.include.list", tableIncludeList)
                .with("topic.prefix", "cargo")
                .with("plugin.name", "pgoutput")
                .with("publication.name", "cargo_publication")
                .with("publication.autocreate.mode", "filtered")
                .with("slot.name", "cargo_slot")
                .with("slot.drop.on.stop", "false")
                .with("slot.stream.params", "include_xids=true")
                .with("slot.max.pending.transactions", "0")
                .with("include.schema.changes", "false")
                .with("include.query", "false")
                .with("tombstones.on.delete", "false")
                .with("snapshot.mode", "initial")
                .with("snapshot.locking.mode", "none")
                .with("snapshot.delay.ms", "0")
                .with("snapshot.fetch.size", "1000")
                .with("max.queue.size", "8192")
                .with("max.batch.size", "2048")
                .with("poll.interval.ms", "1000")
                .with("connect.timeout.ms", "30000")
                .with("database.initial.statements", 
                      "CREATE PUBLICATION IF NOT EXISTS cargo_publication FOR TABLE cargo;")
                .build();
    }
    
    private String extractHostname(String url) {
        // jdbc:postgresql://localhost:5432/cargo_db
        String[] parts = url.replace("jdbc:postgresql://", "").split("/")[0].split(":");
        return parts[0];
    }
    
    private String extractPort(String url) {
        // jdbc:postgresql://localhost:5432/cargo_db
        String[] parts = url.replace("jdbc:postgresql://", "").split("/")[0].split(":");
        return parts.length > 1 ? parts[1] : "5432";
    }
    
    private String extractDatabaseName(String url) {
        // jdbc:postgresql://localhost:5432/cargo_db
        return url.split("/")[url.split("/").length - 1];
    }
} 