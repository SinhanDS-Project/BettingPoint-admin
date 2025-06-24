package com.bettopia.admin.model.contents;

import java.sql.Date;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@AllArgsConstructor
@NoArgsConstructor
@Builder
@Data
public class BannerDTO {
	private String uid;
	private String title;
	private String image_path;
	private String banner_link_url;
	private String description;
	private Date created_at;
}
