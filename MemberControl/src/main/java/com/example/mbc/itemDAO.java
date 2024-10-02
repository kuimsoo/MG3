package com.example.mbc;

import java.util.ArrayList;

import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface itemDAO {
	ArrayList<itemDTO> selectpackage(int id);
	ArrayList<itemDTO> selectitem(int id);
	String getImagePath(int id);

}
