package com.bettopia.admin.model.game;

import java.util.List;
import java.util.UUID;
import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

@Repository
public class GameLevelDAO {

	private static final String NAMESPACE = "com.bpoint.gamelevel.";

	@Autowired
	private SqlSessionTemplate sqlSession;

	public List<GameLevelDTO> selectLevelsByGameUid(String game_uid) {
		return sqlSession.selectList(NAMESPACE + "selectLevelsByGameUid", game_uid);
	}

	public int insert(GameLevelDTO dto) {
		dto.setUid(UUID.randomUUID().toString().replace("-", ""));
		return sqlSession.insert(NAMESPACE + "insertGameLevel", dto);
	}

	public int delete(String game_uid) {
		return sqlSession.delete(NAMESPACE + "deleteLevelsByGameUid", game_uid);
	}

}