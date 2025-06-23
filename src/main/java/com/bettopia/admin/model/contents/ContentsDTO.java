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
public class ContentsDTO {
	private String uid;
	private String type;
	private String title;
	private String image_path;
	private String video_url;
	private String banner_link_url;
	private String description;
	private String status;
	private int sort_order;
	private Date created_at;
}
