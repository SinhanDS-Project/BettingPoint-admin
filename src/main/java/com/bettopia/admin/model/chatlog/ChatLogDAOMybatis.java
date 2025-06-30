package com.bettopia.admin.model.chatlog;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

@Repository("chatlogDAO")
public class ChatLogDAOMybatis {
	
	@Autowired
	SqlSession sqlSession;
	String namespace = "com.bpoint.chatlog.";

	public List<ChatLogDTO> selectAll() {
		List<ChatLogDTO> chatlogList = sqlSession.selectList(namespace + "selectAll");
        return chatlogList;
	}
	
	public List<ChatLogDTO> selectAllWithPaging(int offset, int size) {
		Map<String, Object> params = new HashMap<>();
        params.put("offset", offset);
        params.put("size", size);
		List<ChatLogDTO> chatlogList = sqlSession.selectList(namespace + "chatLogWithPaging", params);
		return chatlogList;
	}
	
	public int countChatLog() {
		return sqlSession.selectOne(namespace + "countChatLog");
	}

	public ChatLogDTO selectByUid(String uid) {
		ChatLogDTO chatlog = sqlSession.selectOne(namespace + "selectByUid", uid);
        return chatlog;
	}
	
	public int updateChatLog(ChatLogDTO chatlog) {
		int result = sqlSession.update(namespace + "updateChatLog", chatlog);
        return result;
	}

}
