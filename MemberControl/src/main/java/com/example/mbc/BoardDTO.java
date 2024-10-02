package com.example.mbc;

import lombok.Data;

@Data
public class BoardDTO {
	int id;
	String title;
	String content;
	String writer;
	String created;
	String updated;
}
