package com.bettopia.admin.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
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
import org.springframework.web.bind.annotation.RestController;

import com.bettopia.admin.model.contents.BettubeDTO;
import com.bettopia.admin.model.contents.BettubeService;

@RestController
@RequestMapping("/api/bettube")
public class BettubeRestController {
	
	@Autowired
	BettubeService bettubeService;
	
	@GetMapping("/allBettube")
	public Map<String, Object> getAllBettube() {
		List<BettubeDTO> bettubes = bettubeService.selectAll();
		Map<String, Object> result = new HashMap<>();
		result.put("data", bettubes);
		return result;
	}
	
	@PostMapping(value = "/insertBettube", produces = "text/plain;charset=utf-8", 
			consumes = MediaType.APPLICATION_JSON_VALUE)
	public String insertBettube(@RequestBody BettubeDTO bettubeDTO) {
		bettubeDTO.setUid(UUID.randomUUID().toString().replace("-", ""));
		int result = bettubeService.insertBettube(bettubeDTO);
    	return result>0?"영상 등록이 완료되었습니다.":"영상 등록에 실패하였습니다.";
   
	}
	
	@PutMapping(value = "/updateBettube", produces = "text/plain;charset=utf-8", 
			consumes = MediaType.APPLICATION_JSON_VALUE)
	public String updateBettube(@RequestBody BettubeDTO bettubeDTO) {
		int result = bettubeService.updateBettube(bettubeDTO);
    	return result>0?"영상 수정이 완료되었습니다.":"영상 수정에 실패하였습니다.";
   
	}
	
	@DeleteMapping(value="/deleteBettube/{uid}", produces = "text/plain;charset=utf-8")
    public String deleteBettube(@PathVariable("uid") String uid) {
    	int result = bettubeService.deleteBettube(uid);
    	return result>0?"삭제 성공하였습니다.":"삭제 실패하였습니다.";
    }
}
