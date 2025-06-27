//package com.sourcing.sourcingimm.config.Gateway;
//
//import jakarta.servlet.FilterChain;
//import jakarta.servlet.ServletException;
//import jakarta.servlet.http.HttpServletRequest;
//import jakarta.servlet.http.HttpServletResponse;
//import org.slf4j.Logger;
//import org.slf4j.LoggerFactory;
//import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
//import org.springframework.security.core.authority.SimpleGrantedAuthority;
//import org.springframework.security.core.context.SecurityContextHolder;
//import org.springframework.web.filter.OncePerRequestFilter;
//
//import java.io.IOException;
//import java.util.Collections;
//
//public class GatewayRequestFilter extends OncePerRequestFilter {
//
//    private final String gatewaySecretHeader;
//    private final String expectedGatewaySecret;
//    private final String allowedGatewayIp;
//
//    private static final Logger logger = LoggerFactory.getLogger(GatewayRequestFilter.class);
//
//    // Constructeur pour injecter les valeurs
//    public GatewayRequestFilter(String gatewaySecretHeader, String expectedGatewaySecret, String allowedGatewayIp) {
//        this.gatewaySecretHeader = gatewaySecretHeader;
//        this.expectedGatewaySecret = expectedGatewaySecret;
//        this.allowedGatewayIp = allowedGatewayIp;
//    }
//
//    @Override
//    protected void doFilterInternal(HttpServletRequest request, HttpServletResponse response, FilterChain filterChain) throws ServletException, IOException {
//        String requestPath = request.getRequestURI();
//
//        // To authorise public authentification endpoints and health check
//        if (requestPath.startsWith("/api/database") || requestPath.equals("/actuator/health")) {
//            filterChain.doFilter(request, response);
//            return;
//        }
//
//        // Validate that the request is from the gateway
//        if (!isValidGatewayRequest(request)) {
//            logger.warn("Non autorise request from IP: {}, Path: {}",
//                    getClientIpAddress(request), requestPath);
//            response.setStatus(HttpServletResponse.SC_FORBIDDEN);
//            response.setContentType("application/json");
//            response.getWriter().write("{\"error\":\"Access denied - non autorise request\"}");
//            return;
//        }
//
//        // Créer une authentification Spring Security
//        UsernamePasswordAuthenticationToken authentication =
//                new UsernamePasswordAuthenticationToken(
//                        "gateway",
//                        null,
//                        Collections.singletonList(new SimpleGrantedAuthority("ROLE_GATEWAY"))
//                );
//        SecurityContextHolder.getContext().setAuthentication(authentication);
//
//        logger.info("Request validated from the gateway for: {}", requestPath);
//        filterChain.doFilter(request, response);
//    }
//
//    private boolean isValidGatewayRequest(HttpServletRequest request) {
//        String clientIp = getClientIpAddress(request);
//
//        logger.info("=== Gateway Validation Debug ===");
//        logger.info("Client IP: {}", clientIp);
//        logger.info("Expected IP: {}", allowedGatewayIp);
//        logger.info("Gateway secret header name: {}", gatewaySecretHeader);
//        logger.info("Expected secret: {}", expectedGatewaySecret);
//
//        // Vérification IP corrigée
//        if (!isValidIp(clientIp)) {
//            logger.warn("IP not authorized: {}, expected IP: {}", clientIp, allowedGatewayIp);
//            return false;
//        }
//
//        // Vérification du secret
//        String gatewaySecret = request.getHeader(gatewaySecretHeader);
//        logger.info("Received gateway secret: {}", gatewaySecret);
//
//        if (gatewaySecret == null || !expectedGatewaySecret.equals(gatewaySecret)) {
//            logger.warn("Invalid gateway secret. Expected: {}, Received: {}", expectedGatewaySecret, gatewaySecret);
//            return false;
//        }
//
//        logger.info("Gateway request validation successful");
//        return true;
//    }
//
//    private boolean isValidIp(String clientIp) {
//        // Si l'IP attendue est localhost ou 127.0.0.1, accepter les variantes locales
//        if ("localhost".equals(allowedGatewayIp) || "127.0.0.1".equals(allowedGatewayIp)) {
//            return "127.0.0.1".equals(clientIp) ||
//                    "localhost".equals(clientIp) ||
//                    "::1".equals(clientIp) ||
//                    "0:0:0:0:0:0:0:1".equals(clientIp);
//        }
//
//        // Sinon, vérification exacte
//        return allowedGatewayIp.equals(clientIp);
//    }
//
//    private String getClientIpAddress(HttpServletRequest request) {
//        logger.info("=== DEBUG getClientIpAddress ===");
//        logger.info("X-Forwarded-For header: '{}'", request.getHeader("X-Forwarded-For"));
//        logger.info("X-Real-IP header: '{}'", request.getHeader("X-Real-IP"));
//        logger.info("X-Gateway-Secret header: '{}'", request.getHeader("X-Gateway-Secret"));
//        logger.info("Remote address: '{}'", request.getRemoteAddr());
//
//        String xForwardedFor = request.getHeader("X-Forwarded-For");
//        if (xForwardedFor != null && !xForwardedFor.isEmpty()) {
//            String ip = xForwardedFor.split(",")[0].trim();
//            logger.info("Using X-Forwarded-For IP: '{}'", ip);
//            return ip;
//        }
//
//        String xRealIp = request.getHeader("X-Real-IP");
//        if (xRealIp != null && !xRealIp.isEmpty()) {
//            logger.info("Using X-Real-IP: '{}'", xRealIp);
//            return xRealIp;
//        }
//
//        logger.info("Using remote address: '{}'", request.getRemoteAddr());
//        return request.getRemoteAddr();
//    }
//}