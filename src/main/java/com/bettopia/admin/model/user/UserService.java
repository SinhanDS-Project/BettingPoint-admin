package com.bettopia.admin.model.user;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Service;

@Service
public class UserService {

	@Autowired
	@Qualifier("userDAO")
	UserDAOMybatis userDAO;
	
	public List<UserDTO> selectAll() {
		return userDAO.selectAll();
	}
	
	public List<UserDTO> selectAllWithPaging(int page) {
		int size = 5;
        int offset = (page-1) * size;
		return userDAO.selectAllWithPaging(offset, size);
	}
	
	public int countUser() {
		return userDAO.countUser();
	}
	
	public UserDTO selectByUid(String uid) {
		return userDAO.selectByUid(uid);
	}
	
	public int updateUser(UserDTO user) {
		return userDAO.updateUser(user);
	}
	
	public int deleteUser(String uid) {
		return userDAO.deleteUser(uid);
	}
}
