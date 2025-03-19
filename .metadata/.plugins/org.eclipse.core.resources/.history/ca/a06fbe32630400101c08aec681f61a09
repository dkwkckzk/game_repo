package com.care.boot.config;

import org.springframework.context.annotation.Configuration;
import org.springframework.messaging.simp.config.MessageBrokerRegistry;
import org.springframework.web.socket.config.annotation.EnableWebSocketMessageBroker;
import org.springframework.web.socket.config.annotation.StompEndpointRegistry;
import org.springframework.web.socket.config.annotation.WebSocketMessageBrokerConfigurer;

@Configuration
@EnableWebSocketMessageBroker
public class WebSocketConfig implements WebSocketMessageBrokerConfigurer {

    @Override
    public void configureMessageBroker(MessageBrokerRegistry config) {
        config.enableSimpleBroker("/topic");  // ✅ 클라이언트가 메시지를 받을 때 사용하는 prefix
        config.setApplicationDestinationPrefixes("/app"); // ✅ 클라이언트가 메시지를 보낼 때 사용하는 prefix
    }

    @Override
    public void registerStompEndpoints(StompEndpointRegistry registry) {
        registry.addEndpoint("/game")
                .setAllowedOriginPatterns("*")  // ✅ 와일드카드 사용 가능
                .withSockJS();
    }

}
