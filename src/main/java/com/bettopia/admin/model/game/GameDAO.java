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

  /** 1) ���� ���� */
  public int insert(GameDTO dto) {
    dto.setUid(UUID.randomUUID().toString().replace("-", ""));
    return sqlSession.insert(NAMESPACE + "insert", dto);
  }

  /** 2) ���� ���� */
  public int update(GameDTO dto) {
    return sqlSession.update(NAMESPACE + "update", dto);
  }

  /** 3) ���� ���� */
  public int delete(String uid) {
    GameDTO dto = GameDTO.builder().uid(uid).build();
    return sqlSession.delete(NAMESPACE + "delete", dto);
  }
  
  public List<GameDTO> selectAll() {
	    return sqlSession.selectList("com.bpoint.game.selectAll");
	}
}