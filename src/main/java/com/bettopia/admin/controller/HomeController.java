package com.bettopia.admin.controller;

import java.text.DateFormat;
import java.util.Date;
import java.util.Locale;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

/**
 * Handles requests for the application home page.
 */
@Controller
public class HomeController {
	
	private static final Logger logger = LoggerFactory.getLogger(HomeController.class);
	
	/**
	 * Simply selects the home view to render by returning its name.
	 */
	@RequestMapping(value = "/", method = RequestMethod.GET)
	public String home(Locale locale, Model model) {
		logger.info("Welcome home! The client locale is {}.", locale);
		
		Date date = new Date();
		DateFormat dateFormat = DateFormat.getDateTimeInstance(DateFormat.LONG, DateFormat.LONG, locale);
		
		String formattedDate = dateFormat.format(date);
		
		model.addAttribute("serverTime", formattedDate );
		
		return "home";
	}
		
	// 회원 관리 페이지
	@GetMapping("/user")
	public String userManagePage(Model model) {
		return "user/user"; 
	}
	
	// 게시판 관리 페이지
	@GetMapping("/board")
	public String boardManagePage(Model model) {
		return "board/board"; 
	}
	
	// 컨텐츠 관리 페이지 (배튜브)
	@GetMapping("/bettube")
	public String contentsManagePage(Model model) {
		return "bettube/bettube"; 
	}
	
	// 게임 통계 관리 페이지 (배튜브)
	@GetMapping("/game_statistics")
	public String statisticsManagePage(Model model) {
		return "game/statistics"; 
	}
	
	// 게임 관리 페이지
	@GetMapping("/game")
	public String gameManagePage(Model model) {
		return "game/game"; 
	}
	
	// 챗봇 관리 페이지
	@GetMapping("/chatbot")
    public String chatbotManagePage(Model model) {
        return "chatbot/adminChatQA"; 
    }
	
}
