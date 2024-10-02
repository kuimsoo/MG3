package com.example.mbc;

import lombok.Data;

@Data
public class replyDTO {
	int id;
	int par_id;
	String content;
	int writer;
	String created;
	String updated;
	String userid;

}
