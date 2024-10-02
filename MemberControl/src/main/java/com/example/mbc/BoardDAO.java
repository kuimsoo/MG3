package com.example.mbc;

import java.util.ArrayList;

import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface BoardDAO {
	void insert(String a, String b, String c);
	ArrayList<BoardDTO> getList(int start);
	BoardDTO getView(int x);
	int getCount();
	void delete(int x);
	void update(int x, String y, String z);
	void addHit(int x);
	void insertBoard(String x,String y,String z);
	void deleteBoard(int x);
	
}
