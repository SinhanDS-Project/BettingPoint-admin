package com.bettopia.admin.controller;

import java.util.List;
import java.util.UUID;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import com.bettopia.admin.model.aws.S3FileService;
import com.bettopia.admin.model.contents.BannerService;
import com.bettopia.admin.model.game.GameDTO;
import com.bettopia.admin.model.game.GameDetailDTO;
import com.bettopia.admin.model.game.GameLevelDTO;
import com.bettopia.admin.model.game.GameLevelService;
import com.bettopia.admin.model.game.GameService;

import lombok.RequiredArgsConstructor;

@RestController
@RequestMapping("/api/game")
@RequiredArgsConstructor
public class GameRestController {

	final GameService gameService;
    final GameLevelService gameLevelService;
    final S3FileService s3FileService;

    // ✅ 전체 게임 목록 조회
    @GetMapping("/list")
    public List<GameDTO> getAllGames() {
        return gameService.selectAll();
    }

    // ✅ 특정 게임 조회 (게임 + 레벨 목록)
    @GetMapping("/{uid}")
    public GameDetailDTO getGameDetail(@PathVariable String uid) {
        GameDTO game = gameService.selectByUid(uid);
        List<GameLevelDTO> levels = gameLevelService.selectLevelsByGameUid(uid);

        return GameDetailDTO.builder()
                .game(game)
                .levels(levels)
                .build();
    }

    // ✅ 게임 + 게임레벨 등록
    @PostMapping(value="/create",
    		consumes = MediaType.MULTIPART_FORM_DATA_VALUE,
            produces = MediaType.TEXT_PLAIN_VALUE + ";charset=UTF-8")
    public String createGameWithLevels(@RequestPart("game") GameDetailDTO req,
    								   @RequestPart(value = "file") MultipartFile file) {
        GameDTO game = req.getGame();
        
        // 파일 업로드 및 파일명 불러오기
 	    String imgName = s3FileService.uploadFile(file);
 	    game.setGame_img(imgName);

        int gameResult = gameService.insert(game);

        int levelset = 0; // level 묶음(상, 중, 하)
        for (GameLevelDTO level : req.getLevels()) {
            level.setUid(UUID.randomUUID().toString().replace("-", ""));
            level.setGame_uid(game.getUid());
            levelset += gameLevelService.insert(level);
        }

        return (gameResult == 1 && levelset == req.getLevels().size()) ? 
					"게임 등록에 성공하였습니다." : "게임 등록에 실패하였습니다.";
    }

    // ✅ 게임 + 레벨 수정
    @PostMapping(value="/update", 
			produces = MediaType.TEXT_PLAIN_VALUE + ";charset=UTF-8", 
			consumes = MediaType.MULTIPART_FORM_DATA_VALUE)
    public String updateGameWithLevels(@RequestPart("game") GameDetailDTO req,
    								   @RequestPart(value = "file", required = false) MultipartFile file) {
    	try {
    		GameDTO game = req.getGame();
    		
			// 새로운 파일이 들어왔다면
	        if (file != null && !file.isEmpty()) {
	        	// 기존 이미지 경로
	        	String original = game.getOriginal_image_path();
	        	if (original != null && !original.isBlank()) {
	            	// 기존 이미지 S3에서 삭제
	                s3FileService.deleteObject(original);
	            }
	        	
	        	// 새 이미지 업로드
	        	String newFileName = s3FileService.uploadFile(file);
	        	game.setGame_img(newFileName);
	        }
	        
	        int gameResult = gameService.update(game);

	        // 기존 레벨 삭제 후 다시 삽입
	        gameLevelService.delete(game.getUid());

	        int levelset = 0;
	        for (GameLevelDTO level : req.getLevels()) {
	            level.setUid(UUID.randomUUID().toString().replace("-", ""));
	            level.setGame_uid(game.getUid());
	            levelset += gameLevelService.insert(level);
	        }
	        
	        return (gameResult == 1 && levelset == req.getLevels().size()) ? 
	        			"게임 수정에 성공하였습니다." : "게임 수정에 실패하였습니다.";
    	} catch (Exception e) {
	        e.printStackTrace();
	        return "서버 오류로 인해 배너 수정에 실패하였습니다.";
	    }
    }

    // ✅ 게임 삭제 (레벨 먼저 삭제)
    @DeleteMapping(value="/delete", 
			consumes = MediaType.APPLICATION_JSON_VALUE,
            produces = MediaType.TEXT_PLAIN_VALUE + ";charset=UTF-8")
    public String deleteGame(@RequestBody GameDTO game) { // 게임uid임
    	s3FileService.deleteObject(game.getGame_img());
    	
    	String uid = game.getUid();
        gameLevelService.delete(uid);  // 레벨 먼저 삭제
        int result = gameService.delete(uid);  // 게임 삭제
        return result == 1 ? "게임 삭제에 성공하였습니다." : "게임 삭제에 실패하였습니다.";
    }
}
