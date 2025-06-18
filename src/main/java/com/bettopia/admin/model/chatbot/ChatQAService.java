package com.bettopia.admin.model.chatbot;

import java.util.List;
import java.util.UUID;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Service;

@Service
public class ChatQAService {
	
	@Autowired
	@Qualifier("chatDAO")
	ChatDAOMybatis chatDAO;
	
	public List<ChatQADTO> selectAll() {
		return chatDAO.selectAll();
	}

	public List<ChatQADTO> selectByCate(String category) {
		return chatDAO.selectByCate(category);
	}
	
	public int insertQA(ChatQADTO chatQA) {
		chatQA.setUid(UUID.randomUUID().toString().replace("-", ""));
		return chatDAO.insertQA(chatQA);
	}
	
	public int updateQA(ChatQADTO chatQA) {
		return chatDAO.updateQA(chatQA);
	}
	
	// 질문-답변 삭제
	public int deleteQA(String uid) {
		return chatDAO.deleteQA(uid);
	}
}
