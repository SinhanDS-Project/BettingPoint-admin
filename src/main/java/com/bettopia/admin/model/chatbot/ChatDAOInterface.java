package com.bettopia.admin.model.chatbot;

import java.util.List;

public interface ChatDAOInterface {
	
	// 전체 Q&A 목록 
	public List<ChatQADTO> selectAll();

	// 질문-답변 등록
	public int insertQA(ChatQADTO chatQA);
	
	// 질문-답변 수정
	public int updateQA(ChatQADTO chatQA);
	
	// 질문-답변 삭제
	public int deleteQA(String uid);
	
	
	
}
