package com.bettopia.admin.model.user;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;


@Repository("userDAO")
public class UserDAOMybatis {
	
	@Autowired
	SqlSession sqlSession;
	String namespace = "com.bpoint.user.";
	
	public List<UserDTO> selectAll() {
		List<UserDTO> userlist = sqlSession.selectList(namespace + "selectAll");
        return userlist;
	}
	
	public List<UserDTO> selectAllWithPaging(int offset, int size) {
		Map<String, Object> params = new HashMap<>();
        params.put("offset", offset);
        params.put("size", size);
		List<UserDTO> userlist = sqlSession.selectList(namespace + "selectAllWithPaging", params);
		return userlist;
	}
	
	public int countUser() {
		return sqlSession.selectOne(namespace + "countUser");
	}
	
	public UserDTO selectByUid(String uid) {
		return sqlSession.selectOne(namespace + "selectByUid", uid);
	}
	
	public int updateUser(UserDTO user) {
		int result = sqlSession.update(namespace + "update", user);
        return result;
	}
	
	public int deleteUser(String uid) {
		sqlSession.delete(namespace + "deleteToken", uid);
		int result = sqlSession.delete(namespace + "delete", uid);
		
		return result;
	}
		
}
