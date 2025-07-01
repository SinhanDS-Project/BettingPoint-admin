package com.bettopia.admin.model.game;

import java.util.List;
import java.util.UUID;
import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

@Repository
public class GameDAO {

	private static final String NAMESPACE = "com.bpoint.game.";

	@Autowired
	private SqlSessionTemplate sqlSession;

	public List<GameDTO> selectAll() {
		return sqlSession.selectList(NAMESPACE + "selectAll");
	}
	
	public GameDTO selectByUid(String uid) {
		return sqlSession.selectOne(NAMESPACE + "selectByUid", uid);
	}

	public int insert(GameDTO dto) {
		dto.setUid(UUID.randomUUID().toString().replace("-", ""));
		return sqlSession.insert(NAMESPACE + "insert", dto);
	}

	public int update(GameDTO dto) {
		return sqlSession.update(NAMESPACE + "update", dto);
	}

	public int delete(String uid) {
		return sqlSession.delete(NAMESPACE + "delete", uid);
	}

}