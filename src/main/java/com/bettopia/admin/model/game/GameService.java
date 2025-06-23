package com.bettopia.admin.model.game;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class GameService {

    @Autowired
    private GameDAO gameDAO;

    // ➕ 등록
    public int create(GameDTO dto) {
        return gameDAO.insert(dto);
    }

    // ✏️ 수정
    public int update(GameDTO dto) {
        return gameDAO.update(dto);
    }

    // ❌ 삭제 (uid 기준)
    public int removeByUid(String uid) {
        return gameDAO.delete(uid);
    }

    // 📄 전체 조회
    public List<GameDTO> getAll() {
        return gameDAO.selectAll();
    }

 
}