package com.bettopia.admin.controller;

import java.util.List;
import java.util.UUID;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.bettopia.admin.model.chatbot.ChatQADTO;
import com.bettopia.admin.model.chatbot.ChatQAService;


@RestController
@RequestMapping("/api/chat")
public class ChatRestController {

	@Autowired
	ChatQAService chatService;
	
	// 질문 전체 리스트 반환
    @GetMapping("/question")
    public List<ChatQADTO> getAllQuestions() {
        return chatService.selectAll();
    }
    
    @PostMapping(value="/insertqa", produces = "text/plain;charset=utf-8", 
			consumes = MediaType.APPLICATION_JSON_VALUE)
    public String insertQA(@RequestBody ChatQADTO chatQA) {
    	chatQA.setUid(UUID.randomUUID().toString().replace("-", ""));	
    	int result = chatService.insertQA(chatQA);
    	return result>0?"질문 등록이 완료되었습니다.":"질문 등록에 실패하였습니다.";
    }
    
    @PutMapping(value="/updateqa", produces = "text/plain;charset=utf-8", 
    		consumes = MediaType.APPLICATION_JSON_VALUE)
    public String updateQA(@RequestBody ChatQADTO chatQA) {
    	int result = chatService.updateQA(chatQA);
    	return result>0?"수정에 성공하였습니다.":"수정에 실패하였습니다.";
    }
    
    @DeleteMapping(value="/deleteqa/{uid}", produces = "text/plain;charset=utf-8")
    public String deleteQA(@PathVariable("uid") String uid) {
    	int result = chatService.deleteQA(uid);
    	return result>0?"삭제 성공하였습니다.":"삭제 실패하였습니다.";
    }
    
    
	
}
