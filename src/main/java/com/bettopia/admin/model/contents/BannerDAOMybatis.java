package com.bettopia.admin.model.contents;

import java.util.List;
import java.util.UUID;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

@Repository("bannerDAO")
public class BannerDAOMybatis implements BannerDAOInterface {
	
	@Autowired
	SqlSession sqlSession;
	String namespace = "com.bpoint.banner.";
	
	
	@Override
	public List<BannerDTO> selectAll() {
		List<BannerDTO> bannerList = sqlSession.selectList(namespace + "selectAll");
		System.out.println(bannerList!=null?bannerList.toString():"" + "조회됨");
		return bannerList;
	}

	@Override
	public int insertBanner(BannerDTO bannerDTO) {		
		int result = sqlSession.insert(namespace + "insert", bannerDTO);
		System.out.println(bannerDTO.toString());
		System.out.println(result + "건 등록");
		return result;
	}

	@Override
	public int updateBanner(BannerDTO bannerDTO) {
		int result = sqlSession.update(namespace + "update", bannerDTO);
		System.out.println(bannerDTO.toString());
		System.out.println(result + "건 수정");
		return result;
	}

	@Override
	public int deleteBanner(String uid) {
		int result = sqlSession.delete(namespace + "delete", uid);
		System.out.println("삭제된 uid: " + uid);
		System.out.println(result + "건 삭제");
		return result;
	}
	
}
