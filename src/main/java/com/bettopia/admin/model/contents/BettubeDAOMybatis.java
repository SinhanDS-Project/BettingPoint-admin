package com.bettopia.admin.model.contents;

import java.util.List;
import java.util.UUID;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

@Repository("bettubeDAO")
public class BettubeDAOMybatis implements BettubeDAOInterface {
	
	@Autowired
	SqlSession sqlSession;
	String namespace = "com.bpoint.bettube.";
	
	
	@Override
	public List<BettubeDTO> selectAll() {
		List<BettubeDTO> bettubeList = sqlSession.selectList(namespace + "selectAll");
		return bettubeList;
	}

	@Override
	public int insertBettube(BettubeDTO bettubedto) {		
		int result = sqlSession.insert(namespace + "insert", bettubedto);
		System.out.println(result + "건 등록");
		return result;
	}

	@Override
	public int updateBettube(BettubeDTO bettubedto) {
		int result = sqlSession.update(namespace + "update", bettubedto);
		System.out.println(result + "건 수정");
		return result;
	}

	@Override
	public int deleteBettube(String uid) {
		int result = sqlSession.delete(namespace + "delete", uid);
		System.out.println(result + "건 삭제");
		return result;
	}
	
}
