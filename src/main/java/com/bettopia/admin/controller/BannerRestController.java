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
import org.springframework.web.bind.annotation.RequestPart;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;

import com.bettopia.admin.model.aws.S3FileService;
import com.bettopia.admin.model.chatbot.ChatQADTO;
import com.bettopia.admin.model.contents.BannerDTO;
import com.bettopia.admin.model.contents.BannerService;

import lombok.RequiredArgsConstructor;

@RestController
@RequestMapping("/api/banner")
@RequiredArgsConstructor
public class BannerRestController {	
	
	final BannerService bannerService;
	final S3FileService s3FileService;
	
	@GetMapping("/allBanner")
	public Map<String, Object> getAllBanners(){
		List<BannerDTO> banners = bannerService.selectAll();
		Map<String, Object> result = new HashMap<>();
		result.put("data", banners);
		return result;
	}
	
	@PostMapping(value="/insertBanner", 
	            consumes = MediaType.MULTIPART_FORM_DATA_VALUE,
	            produces = MediaType.TEXT_PLAIN_VALUE + ";charset=UTF-8")
	public String insertBanner(@RequestPart("banner") BannerDTO banner,
	                          @RequestPart("file") MultipartFile file) {
	
	   banner.setUid(UUID.randomUUID().toString().replace("-", ""));
	   
	   // 파일 업로드 및 파일명 불러오기
	   String imgName = s3FileService.uploadFile(file);
	   banner.setImage_path(imgName);
	
	   int result = bannerService.insertBanner(banner);
	   return result > 0 ? "배너 등록이 완료되었습니다." : "배너 등록에 실패하였습니다.";
	}
	
	@PutMapping(value="/updateBanner", 
			produces = MediaType.TEXT_PLAIN_VALUE + ";charset=UTF-8", 
    		consumes = MediaType.APPLICATION_JSON_VALUE)
    public String updateBanner(@RequestBody BannerDTO banner) {
    	int result = bannerService.updateBanner(banner);
    	return result>0?"배너 수정에 성공하였습니다.":"배너 수정에 실패하였습니다.";
    }
	
	@DeleteMapping(value="/deleteBanner", 
			consumes = MediaType.APPLICATION_JSON_VALUE,
            produces = MediaType.TEXT_PLAIN_VALUE + ";charset=UTF-8")
    public String deleteBanner(@RequestBody BannerDTO banner) {
		s3FileService.deleteObject(banner.getImage_path());
		
    	int result = bannerService.deleteBanner(banner.getUid());
    	return result>0?"삭제 성공하였습니다.":"삭제 실패하였습니다.";
    }
	
}
