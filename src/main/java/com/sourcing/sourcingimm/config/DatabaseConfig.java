package com.sourcing.sourcingimm.config;

import lombok.Data;
import org.jooq.DSLContext;
import org.jooq.SQLDialect;
import org.jooq.conf.RenderNameCase;
import org.jooq.conf.RenderQuotedNames;
import org.jooq.conf.Settings;
import org.jooq.impl.DSL;
import org.jooq.impl.DefaultConfiguration;
import org.springframework.boot.context.properties.ConfigurationProperties;
import org.springframework.boot.context.properties.EnableConfigurationProperties;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.jdbc.datasource.TransactionAwareDataSourceProxy;
import org.springframework.transaction.annotation.EnableTransactionManagement;

import javax.sql.DataSource;

@Configuration
@EnableTransactionManagement
@EnableConfigurationProperties(DatabaseConfig.DatabaseProperties.class)
public class DatabaseConfig {

    @Bean
    public Settings jooqSettings() {
        return new Settings()
                .withRenderQuotedNames(RenderQuotedNames.EXPLICIT_DEFAULT_QUOTED)
                .withRenderNameCase(RenderNameCase.AS_IS)
                .withRenderSchema(true)  // Changed to true to include schema names
                .withExecuteLogging(true)
                .withQueryTimeout(30)
                .withFetchSize(1000);
    }

    @Bean
    public DefaultConfiguration jooqConfiguration(DataSource dataSource, Settings jooqSettings) {
        DefaultConfiguration configuration = new DefaultConfiguration();
        configuration.set(new TransactionAwareDataSourceProxy(dataSource));
        configuration.set(SQLDialect.POSTGRES);  // Add SQL dialect
        configuration.set(jooqSettings);
        return configuration;
    }

    @Bean
    public DSLContext dslContext(DefaultConfiguration jooqConfiguration) {
        return DSL.using(jooqConfiguration);
    }

    @Data
    @ConfigurationProperties(prefix = "app.database")
    public static class DatabaseProperties {
        private int queryTimeout = 3000;
        private int batchSize = 1000;
    }
}