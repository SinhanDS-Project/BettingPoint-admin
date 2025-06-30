package com.bettopia.admin.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.web.bind.annotation.*;

import com.bettopia.admin.model.chatlog.ChatLogDTO;
import com.bettopia.admin.model.chatlog.ChatLogResponseDTO;
import com.bettopia.admin.model.chatlog.ChatLogService;

@RestController
@RequestMapping("/api/chatlog")
public class ChatLogRestController {

	@Autowired
	ChatLogService chatLogService;
	
	@GetMapping("")
	public List<ChatLogDTO> selectAll(){
		return chatLogService.selectAll();
	}
	
	// ✅ 사용자 UID로 채팅 로그 전체 조회
//    @GetMapping("")
//    public ChatLogResponseDTO getLogsByUserWithPaging(
//										@RequestHeader("Authorization") String authHeader,
//										@RequestParam(defaultValue = "1") int page) {
//    	String userId = authService.validateAndGetUserId(authHeader);
//    	List<ChatLogDTO> list = chatLogService.selectByUser(userId, page);
//    	int totalCount = chatLogService.chatlogCount(userId);
//    	return ChatLogResponseDTO.builder()
//    			.logs(list)
//    			.total(totalCount)
//    			.build();
//    }
    
    // ✅ UID로 채팅 로그 상세 조회
    @GetMapping("/detail/{chatlog_uid}")
    public ChatLogDTO getLogByUid(@PathVariable String chatlog_uid) {
        return chatLogService.selectByUid(chatlog_uid);
    }
    
    @PutMapping(value="/updateChatlog", produces = "text/plain;charset=utf-8", 
    									consumes = MediaType.APPLICATION_JSON_VALUE)
    public String updateChatlogs(@RequestBody ChatLogDTO chatlog) {
    	int result = chatLogService.updateChatLog(chatlog);
    	
    	return result>0?"답변 등록을 성공하였습니다.":"답변 등록에 실패하였습니다.";
    }
}

   