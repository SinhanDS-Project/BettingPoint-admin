package com.bettopia.admin.model.chatbot;

import java.util.List;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

@Repository("chatDAO")
public class ChatDAOMybatis implements ChatDAOInterface {
	
	@Autowired
	SqlSession sqlSession;
	String namespace = "com.bpoint.chat.";
	
	@Override
	public List<ChatQADTO> selectAll() {
		List<ChatQADTO> chatlist = sqlSession.selectList(namespace + "selectAll");
		return chatlist;
	}

	@Override
	public int insertQA(ChatQADTO chatQA) {
		int result = sqlSession.insert(namespace + "insert", chatQA);
		System.out.println(result + "건 등록");
		return result;
	}

	@Override
	public int updateQA(ChatQADTO chatQA) {
		int result = sqlSession.update(namespace + "update", chatQA);
		System.out.println(result + "건 수정");
		return result;
	}

	@Override
	public int deleteQA(String uid) {
		int result = sqlSession.delete(namespace + "delete", uid);
		System.out.println(result + "건 삭제");
		return result;
	}




}
