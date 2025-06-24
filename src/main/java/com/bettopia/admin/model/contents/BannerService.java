package com.bettopia.admin.model.contents;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Service;

@Service
public class BannerService {
	
	@Autowired
	@Qualifier("bannerDAO")
	BannerDAOMybatis bannerDAO;
	
	public List<BannerDTO> selectAll() {
		return bannerDAO.selectAll();
	}
	
	public int insertBanner(BannerDTO bannerDTO) {
		return bannerDAO.insertBanner(bannerDTO);
	}
	
	public int updateBanner(BannerDTO bannerDTO) {
		return bannerDAO.updateBanner(bannerDTO);
	}
	
	public int deleteBanner(String uid) {
		return bannerDAO.deleteBanner(uid);
	}
}
