package com.bettopia.admin.model.contents;

import java.util.List;

public interface BettubeDAOInterface {

	// 전체 베튜브 목록 
	public List<BettubeDTO> selectAll();
	
	// 베튜브 등록
	public int insertBettube(BettubeDTO bettubedto);
	
	// 베튜브 수정
	public int updateBettube(BettubeDTO bettubedto);
	
	// 베튜브 삭제
	public int deleteBettube(String uid);
}
