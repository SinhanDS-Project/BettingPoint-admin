package com.bettopia.admin.model.contents;

import java.util.List;

public interface BannerDAOInterface {

	// 전체 배너 목록 
	public List<BannerDTO> selectAll();
	
	// 배너 등록
	public int insertBanner(BannerDTO bannerDTO);
	
	// 배너 수정
	public int updateBanner(BannerDTO bannerDTO);
	
	// 배너 삭제
	public int deleteBanner(String uid);
}
