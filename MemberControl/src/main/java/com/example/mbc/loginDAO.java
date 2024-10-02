package com.example.mbc;

import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface loginDAO {
	void insertGet(String userid,String passwd, String realname,String birthday,
			String gender,String mobile, String favorite);
	int loginCheck(String userid,String passwd);
	

}
