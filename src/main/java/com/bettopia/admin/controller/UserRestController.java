package com.bettopia.admin.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.web.bind.annotation.*;

import com.bettopia.admin.model.user.UserDTO;
import com.bettopia.admin.model.user.UserResponseDTO;
import com.bettopia.admin.model.user.UserService;

@RestController
@RequestMapping("/api/user")
public class UserRestController {
	
	@Autowired
	UserService userService;
	
//	@GetMapping("")
//	public List<UserDTO> selectAll() {
//		return userService.selectAll();
//	}
	
	@GetMapping("")
    public UserResponseDTO getUserWithPaging(@RequestParam(defaultValue = "1") int page) {
    	List<UserDTO> list = userService.selectAllWithPaging(page);
    	int totalCount = userService.countUser();
    	return UserResponseDTO.builder()
    			.users(list)
    			.total(totalCount)
    			.build();
    }
	
	@GetMapping("/detail/{uid}")
    public UserDTO selectByUid(@PathVariable String uid) {
        return userService.selectByUid(uid);
    }
	
	@PutMapping(value="/updateUser", produces = "text/plain;charset=utf-8", 
			consumes = MediaType.APPLICATION_JSON_VALUE)
	public String updateUser(@RequestBody UserDTO user) {
		int result = userService.updateUser(user);
		
		return result>0?"권한 수정을 성공하였습니다.":"권한 수정에 실패하였습니다.";
	}
	
	@DeleteMapping(value="/deleteUser/{uid}", produces = "text/plain;charset=utf-8")
    public String deleteUser(@PathVariable("uid") String uid) {
    	int result = userService.deleteUser(uid);
    	return result>0?"삭제 성공하였습니다.":"삭제 실패하였습니다.";
    }
}
