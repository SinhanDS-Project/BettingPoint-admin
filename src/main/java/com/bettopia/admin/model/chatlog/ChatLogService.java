package com.bettopia.admin.model.chatlog;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Service;

@Service
public class ChatLogService {

	@Autowired
	@Qualifier("chatlogDAO")
	ChatLogDAOMybatis chatLogDAO;
	
	public List<ChatLogDTO> selectAll() {
		return chatLogDAO.selectAll();
	}
	
	public List<ChatLogDTO> selectAllWithPaging(int page) {
		int size = 10;
        int offset = (page-1) * size;
		return chatLogDAO.selectAllWithPaging(offset, size);
	}
	
	public int chatlogCount(String userId) {
		return chatLogDAO.countChatLog(userId);
	}	
	
	public ChatLogDTO selectByUid(String uid) {
		return chatLogDAO.selectByUid(uid);
	}
	
	public int updateChatLog(ChatLogDTO chatlog) {
		return chatLogDAO.updateChatLog(chatlog);
	}

}
