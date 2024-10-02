package com.example.mbc;

import java.util.ArrayList;


import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface replyDAO {
	void insertreply(int par_id,String content,String userid);
	ArrayList<replyDTO> selectreply(int id);
	void deletereply(int id);
	void updatereply(int a,String b,String c,int d);
	ArrayList<replyDTO> comment(int par_id);
	
}
