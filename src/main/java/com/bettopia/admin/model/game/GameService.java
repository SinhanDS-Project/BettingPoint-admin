package com.bettopia.admin.model.game;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class GameService {

    @Autowired
    private GameDAO gameDAO;

    public List<GameDTO> selectAll() {
    	return gameDAO.selectAll();
    }
    
    public GameDTO selectByUid(String uid) {
    	return gameDAO.selectByUid(uid);
    }
    
    public int insert(GameDTO dto) {
    	return gameDAO.insert(dto);
    }
    
    public int update(GameDTO dto) {
    	return gameDAO.update(dto);
    }
    public int delete(String uid) {
    	return gameDAO.delete(uid);
    }
}