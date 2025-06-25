package com.bettopia.admin.model.contents;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Service;

@Service
public class BettubeService {
	
	@Autowired
	@Qualifier("bettubeDAO")
	BettubeDAOMybatis bettubeDAO;
	
	public List<BettubeDTO> selectAll() {
		return bettubeDAO.selectAll();
	}

	public int insertBettube(BettubeDTO bettubedto) {		
		return bettubeDAO.insertBettube(bettubedto);
	}
	
	public int updateBettube(BettubeDTO bettubedto) {
		return bettubeDAO.updateBettube(bettubedto);
	}
	
	public int deleteBettube(String uid) {
		return bettubeDAO.deleteBettube(uid);
	}
}
