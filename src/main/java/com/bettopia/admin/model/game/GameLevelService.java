package com.bettopia.admin.model.game;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class GameLevelService {

    @Autowired
    private GameLevelDAO GameLevelDAO;

    public List<GameLevelDTO> selectLevelsByGameUid(String game_uid) {
    	return GameLevelDAO.selectLevelsByGameUid(game_uid);
    }
    
    public int insert(GameLevelDTO dto) {
    	return GameLevelDAO.insert(dto);
    }
   
    public int delete(String game_uid) {
    	return GameLevelDAO.delete(game_uid);
    }
}