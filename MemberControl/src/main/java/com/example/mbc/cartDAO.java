package com.example.mbc;


import java.util.ArrayList;

import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface cartDAO {
	void insertcart(String custom_id,int item_id,int qty,int totalprice);
	ArrayList<cartDTO> selectcart(String userid);
	void deletecart(int id,String custom_id);
	void deletecart1(int id,String custom_id);
	int countcart(String customer_id);
	ArrayList<cartDTO> selectitem(int item_id);
	ArrayList<cartDTO> checkitem(String customer_id,int item_id);
	

}
