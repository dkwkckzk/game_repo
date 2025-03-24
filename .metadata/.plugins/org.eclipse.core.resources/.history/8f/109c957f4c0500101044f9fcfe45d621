package com.care.boot.game;

import org.springframework.stereotype.Component;
import java.util.Iterator;
import java.util.Set;
import java.util.concurrent.ConcurrentHashMap;
import java.util.concurrent.ConcurrentLinkedQueue;

@Component
public class GameSessionManager {
    private final Set<String> onlinePlayers = ConcurrentHashMap.newKeySet();
    private final ConcurrentLinkedQueue<String> matchQueue = new ConcurrentLinkedQueue<>();

    public void addPlayer(String playerId) {
        onlinePlayers.add(playerId);
    }

    public void removePlayer(String playerId) {
        onlinePlayers.remove(playerId);
        matchQueue.remove(playerId);
    }

    public Set<String> getOnlinePlayers() {
        return Set.copyOf(onlinePlayers);
    }

    public void addToMatchQueue(String playerId) {
        if (!matchQueue.contains(playerId)) {
            matchQueue.add(playerId);
        }
    }

    public synchronized String findMatch(String playerId) {
        Iterator<String> iterator = matchQueue.iterator();
        while (iterator.hasNext()) {
            String opponent = iterator.next();
            if (!opponent.equals(playerId)) {
                iterator.remove();
                return opponent;
            }
        }
        return null;
    }

    // ✅ 플레이어가 이미 대기 중인지 확인
    public boolean isInQueue(String playerId) {
        return matchQueue.contains(playerId);
    }
}
