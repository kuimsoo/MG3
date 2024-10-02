package com.example.mbc;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

import org.json.JSONArray;
import org.json.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.web.servlet.error.ErrorController;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;

@Controller

public class HomeController implements ErrorController  {
	@Autowired loginDAO ldao;
	@Autowired BoardDAO bdao;
	@Autowired replyDAO redao;
	@Autowired itemDAO itemdao;
	@Autowired cartDAO cartdao;
	
	
	  @RequestMapping("/error")
	    public String handleError() {
	        return "redirect:/"; // 홈으로 리다이렉트
	    }

	
	  	@GetMapping("/")
	    public String home(HttpServletRequest req, Model model) {
	        HttpSession s = req.getSession();
	        String userid = (String) s.getAttribute("userid");
	        String linkstr = "";
	        String newpost = "";

	        if (userid == null || userid.equals("")) {
	            linkstr = "<a href='/login'>로그인</a>&nbsp;&nbsp;&nbsp;<a href='/signup'>회원가입</a>";
	            newpost = "";
	        } else {
	            linkstr = userid + "&nbsp;&nbsp;&nbsp;<a href='/logout'>로그아웃</a>";
	            newpost = "<a href='/write'>새글작성</a>";
	        }
	        model.addAttribute("linkstr", linkstr);
	        model.addAttribute("newpost", newpost);

	        String pageno = req.getParameter("p");
	        int nowpage = 1;
	        if (pageno == null || pageno.equals("")) nowpage = 1;
	        else nowpage = Integer.parseInt(pageno);

	        int total = bdao.getCount();
	        int pagesize = 20;

	        int start = (nowpage - 1) * pagesize;
	        System.out.println(start);
	        int lastpage = (int) Math.ceil((double) total / pagesize);
	        System.out.println("lastpage[" + lastpage + "]");

	        String movestr = "<a href ='/?p=1'>처음</a>&nbsp;&nbsp";
	        if (nowpage != 1) {
	            movestr += "<a href='/?p=" + (nowpage - 1) + "'>이전</a>&nbsp;&nbsp";
	        }
	        if (nowpage != lastpage) {
	            movestr += "<a href='/?p=" + (nowpage + 1) + "'>다음</a>&nbsp;&nbsp";
	        }
	        movestr += "<a href='/?p=" + lastpage + "'>마지막</a>";

	        model.addAttribute("movestr", movestr);

	        ArrayList<BoardDTO> arBoard = bdao.getList(start);
	        System.out.println("size=" + arBoard.size());
	        model.addAttribute("arBoard", arBoard);
	        return "home";
	    }
	@GetMapping("/login")
	public String login() {
		return "login";
	}
	@PostMapping("/doLogin")
	public String doLogin(HttpServletRequest req) {
		String userid = req.getParameter("userid");
		String passwd = req.getParameter("passwd");
		if(userid==null || userid.equals("")) return "redirect:/login";
		if(passwd==null || passwd.equals("")) return "redirect:/login";
		int n = ldao.loginCheck(userid, passwd);
		System.out.println("n="+n);
		if(n>0) { // login성공
			HttpSession s = req.getSession();
			s.setAttribute("userid", userid);
			return "redirect:/";
		} else {	// login실패
			return "redirect:/login";
		}
	}
	@GetMapping("/logout")
	public String logout(HttpServletRequest req) {
		HttpSession s = req.getSession();
		s.invalidate();
		return "redirect:/";
	}
	@GetMapping("/signup")
	public String signup() {
		return "signup";
	}
	@PostMapping("/doSignup")
	public String doSignup(HttpServletRequest req) {
		String userid=req.getParameter("userid");
		String passwd=req.getParameter("passwd");
		String name=req.getParameter("realname");
		String birthday=req.getParameter("birthday");
		String gender=req.getParameter("gender");
		String mobile=req.getParameter("mobile");
		String [] favorite=req.getParameterValues("favorite");
		String str="";
		
		if(favorite!=null) {
		
			for(int i=0;i<favorite.length;i++) {
				str+=favorite[i];
			}
		}
		ldao.insertGet(userid,passwd,name,birthday,gender,mobile,str);	
		
		if(favorite!=null&&favorite.length==0||userid.equals("")||passwd.equals("")||name.equals("")||birthday.equals("")
				||gender.equals("")||mobile.equals("")) {
			
			return "redirect:signup";
		}
		return "login";
	}
	
	//첫번째 여기까지
	
	
	@GetMapping("/board")
	public String showBoard(HttpServletRequest req) {
		HttpSession s = req.getSession();
		String userid = (String)s.getAttribute("userid");
		if( userid==null || userid.equals("")) {
			return "login";
		} 
		return "board";
	}
	@GetMapping("/write")    //게시판 작성하는거
	public String write(HttpServletRequest req, Model model) {
		HttpSession s = req.getSession();
		String userid = (String) s.getAttribute("userid");
		model.addAttribute("userid",userid);
		return "Board/write";
	}
	@PostMapping("/save")          //게시판에서 저장을 눌렀을떄
	public String save(HttpServletRequest req, Model model) {
		String title = req.getParameter("title");
		String writer = req.getParameter("writer");
		String content = req.getParameter("content");
		System.out.println("writer"+writer+"writer"+title+"writer"+content);
		bdao.insert(title, writer, content);
		
		return "redirect:/";
	}
	@GetMapping("/view")    //게시글 
	public String view(HttpServletRequest req, Model model) {
		int id = Integer.parseInt(req.getParameter("id"));
		BoardDTO bdto = bdao.getView(id);
		ArrayList<replyDTO> rdto =redao.selectreply(id);
		bdao.addHit(id);
		model.addAttribute("board",bdto);
		model.addAttribute("arReply",rdto);
		return "Board/view";
	}
	@GetMapping("/delete")    //게시글 삭제
	public String delete(HttpServletRequest req) {
		HttpSession s = req.getSession();
		String userid = (String) s.getAttribute("userid");
		if(userid==null || userid.equals("")) {
			return "redirect:/";
		}
		int id = Integer.parseInt(req.getParameter("id"));
		BoardDTO bdto = bdao.getView(id);
		if(userid.equals(bdto.getWriter())){
			bdao.delete(id);
		}
		return "redirect:/";
	}
	@GetMapping("/update")
	public String update(HttpServletRequest req, Model model) {
		HttpSession s = req.getSession();
		String userid = (String) s.getAttribute("userid");
		if(userid==null || userid.equals("")) {
			return "redirect:/";
		}
		int id = Integer.parseInt(req.getParameter("id"));
		BoardDTO bdto = bdao.getView(id);
		if(userid.equals(bdto.getWriter())){
			model.addAttribute("board",bdto);
			return "Board/update";
		} else {
			return "redirect:/";
		}
	}
	@PostMapping("/modify")  //저장누르면 됨
	public String modify(HttpServletRequest req, Model model) {
		int id = Integer.parseInt(req.getParameter("id"));
		String title = req.getParameter("title");
		String content = req.getParameter("content");
		bdao.update(id, title, content);
		return "redirect:/";
	}	
	
	//여기가 두번쨰

	@GetMapping("/crud")
	public String crud(HttpServletRequest req) {
		HttpSession s=req.getSession();
		String userid=(String) s.getAttribute("userid");
		if(userid==null || userid.equals("")) {
			return "login";
		}
		return "ajax/crud";
	}
	@PostMapping("/list")
	@ResponseBody
	public String doList(HttpServletRequest req) {
		int start=40;
		ArrayList<BoardDTO> arBoard =bdao.getList(start);
		JSONArray ja= new JSONArray();
		for(BoardDTO bdto : arBoard) {
			JSONObject jo = new JSONObject();
			jo.put("id", bdto.getId());
			jo.put("title", bdto.getTitle());
			jo.put("content", bdto.getContent());
			jo.put("author", bdto.getWriter());
			jo.put("created", bdto.getCreated());
			jo.put("updated", bdto.getUpdated());
			
			ja.put(jo);		
		}
		return ja.toString();
	}
	@PostMapping("/addCrud")
	@ResponseBody
	public String addCrud(HttpServletRequest req) {
			HttpSession s=req.getSession();
			String userid=(String) s.getAttribute("userid");
			String title=req.getParameter("title");
			String content=req.getParameter("content");
			
			bdao.insertBoard(title,userid,content);
			return "ok";
	}
	@PostMapping("deleteBoard")
	@ResponseBody
	public String deleteBoard(HttpServletRequest req) {
		int id = Integer.parseInt(req.getParameter("id"));
		bdao.deleteBoard(id);
		return "ok";
	}
	@PostMapping("/insertreply")
	@ResponseBody
	public String insertreply(HttpServletRequest req) {
		int par_id=Integer.parseInt(req.getParameter("id"));
		String reply=req.getParameter("reply");
		String writer=req.getParameter("writer");
		
		redao.insertreply(par_id, reply, writer);
		
	
		return "ok";
	}
	@PostMapping("/deletereply")
	@ResponseBody
	public String deletereply(HttpServletRequest req) {
		int id=Integer.parseInt(req.getParameter("rep"));	
		redao.deletereply(id);
		return "ok";
	}
	@PostMapping("/updatereply")
	@ResponseBody
	public String updatereply(HttpServletRequest req) {
		int par_id=Integer.parseInt(req.getParameter("par_id"));
		String reply=req.getParameter("reply");
		String writer=req.getParameter("writer");
		int id=Integer.parseInt(req.getParameter("id"));
		
		redao.updatereply(par_id, reply, writer,id);
		
		return "ok";
		
	}
	@PostMapping("/replyreply")
	@ResponseBody
	public String replyreply(HttpServletRequest req) {
		int par_id=Integer.parseInt(req.getParameter("par_id"));
		String reply=req.getParameter("replyreply");
		String writer=req.getParameter("writer");
		
		redao.insertreply(par_id, reply, writer);
		
		return "ok";
	}
	@PostMapping("/comment")
	@ResponseBody
	public String comment(HttpServletRequest req) {
		int par_id=Integer.parseInt(req.getParameter("par_id"));

		ArrayList<replyDTO> arReply =redao.comment(par_id);
		JSONArray ja= new JSONArray();
		for(replyDTO bdto : arReply) {
			JSONObject jo = new JSONObject();
			jo.put("id", bdto.getId());
			jo.put("par_id",bdto.getPar_id());
			jo.put("content", bdto.getContent());
			jo.put("userid", bdto.getUserid());
			jo.put("created",bdto.getCreated());
			jo.put("updated",bdto.getUpdated());

			ja.put(jo);		
		}
		return ja.toString();
	
	}
	@GetMapping("/store")
	public String store(HttpServletRequest req,Model model) {
		HttpSession s=req.getSession();
		String userid=(String) s.getAttribute("userid");
		
		
		model.addAttribute("userid",userid);
		return "store/store";
	}
	@GetMapping("/details")
	public String details(HttpServletRequest req,Model model) {
	    int id = Integer.parseInt(req.getParameter("id"));
	    System.out.println(id);
	    
		ArrayList<itemDTO> arPackage = itemdao.selectpackage(id);
		System.out.println("item="+arPackage.size());
		ArrayList<itemDTO> arItem = itemdao.selectitem(id);
	
		String imagePath = itemdao.getImagePath(id);
		
		HttpSession s=req.getSession();
		String userid=(String) s.getAttribute("userid");
		
		
		model.addAttribute("arPackage",arPackage);
		model.addAttribute("arItem",arItem);
		model.addAttribute("imagePath", imagePath);
		model.addAttribute("userid", userid);
			
	    return "store/details";
	}
	@GetMapping("/cart")
	public String cart(HttpServletRequest req,Model model) {
		HttpSession s=req.getSession();
		String userid=(String) s.getAttribute("userid");
		System.out.println(userid);
		
		ArrayList<cartDTO> arCart=cartdao.selectcart(userid);
		
		model.addAttribute("arCart",arCart);
		
		return "store/cart";
	}
	@GetMapping("/storepay")
	public String storepay(HttpServletRequest req) {
		
		
		return "store/storepay";
	}
	@PostMapping("insertcart")
	@ResponseBody
	public String insertcart(HttpServletRequest req) {
		HttpSession s=req.getSession();
		String custom_id=(String) s.getAttribute("userid");

		 int item_id=Integer.parseInt(req.getParameter("item_id"));
		 int qty=Integer.parseInt(req.getParameter("qty"));
		 int totalprice=Integer.parseInt(req.getParameter("totalprice"));
		 
		 cartdao.insertcart(custom_id,item_id,qty,totalprice);
		
	
		return "ok";
	}
	@PostMapping("/deletecart")
	@ResponseBody
	public String deletecart(HttpServletRequest req) {
		int item_id=Integer.parseInt(req.getParameter("item_id"));
		String custom_id=req.getParameter("custom_id");
		
		cartdao.deletecart(item_id, custom_id);
		
		return "ok";
	}
	@PostMapping("/choicedelete")
	@ResponseBody
	public String choicedelete(@RequestBody Map<String, List<String>> requestBody, HttpServletRequest req) {
	    HttpSession session = req.getSession();
	    String custom_id = (String) session.getAttribute("userid");
	    if (custom_id == null) {
	        return "User not logged in";
	    }
	    
	    List<String> itemIds = requestBody.get("item_id");
	    if (itemIds == null || itemIds.isEmpty()) {
	        return "No items selected";
	    }
	    
	    for (String itemId : itemIds) {
	        try {
	            int itemIdInt = Integer.parseInt(itemId);
	            cartdao.deletecart(itemIdInt, custom_id); // 데이터베이스에서 항목 삭제
	        } catch (NumberFormatException e) {
	            return "Invalid item ID: " + itemId;
	        }
	    }
	    
	    return "ok";
	}
	
    @PostMapping("/dostorepay")
    public String dostorepay(@RequestParam("productData") String productData, Model model) {
        ObjectMapper objectMapper = new ObjectMapper();
        Map<String, Object> dataMap;

        try {
            // JSON 문자열을 Map으로 변환
            dataMap = objectMapper.readValue(productData, new TypeReference<Map<String, Object>>() {});
        } catch (IOException e) {
            e.printStackTrace();
            // JSON 파싱 오류 처리
            dataMap = Map.of(); // 빈 Map으로 대체
        }

        // 변환된 데이터를 모델에 추가
    

        model.addAttribute("items", dataMap.get("items"));
        model.addAttribute("totalPrice", dataMap.get("totalPrice"));
     
        model.addAttribute("totalDiscount", dataMap.get("totalDiscount"));
        model.addAttribute("finalPrice", dataMap.get("finalPrice"));
        
        System.out.println("Final Price: " + dataMap.get("finalPrice"));

        // JSP 파일명 반환
        return "store/storepay";
    }
    @PostMapping("/countcart")
	@ResponseBody
	public String conuntcart(HttpServletRequest req) {
		  HttpSession session = req.getSession();
		  String custom_id = (String) session.getAttribute("userid");
		
		  int n=cartdao.countcart(custom_id);
		  
		return ""+n;
	}
    @PostMapping("/selectitem")
    @ResponseBody
    public String selectitem(HttpServletRequest req) {
    	 int item_id = Integer.parseInt(req.getParameter("item_id"));
    	 System.out.println(item_id);
    	
    	ArrayList<cartDTO> arCart =cartdao.selectitem(item_id);
		JSONArray ja= new JSONArray();
		for(cartDTO bdto : arCart) {
			JSONObject jo = new JSONObject();
			jo.put("id", bdto.getId());
			jo.put("discount_price",bdto.getDiscount_price());
			jo.put("price", bdto.getPrice());
			jo.put("composition", bdto.getComposition());
			jo.put("name",bdto.getName());
			jo.put("image_path",bdto.getImage_path());

			ja.put(jo);		
		}
		return ja.toString();
    }
    @PostMapping("/checkitem")
	   @ResponseBody
	   public String checkitem(HttpServletRequest req) {
		   HttpSession session = req.getSession();
		   String custom_id = (String) session.getAttribute("userid");
		   int item_id=Integer.parseInt(req.getParameter("item_id"));
				
		   System.out.println("item"+item_id);
		   ArrayList<cartDTO> arCart =cartdao.checkitem(custom_id,item_id);
			JSONArray ja= new JSONArray();
			for(cartDTO bdto : arCart) {
				JSONObject jo = new JSONObject();
//				jo.put("id", bdto.getId());
				jo.put("item_count", bdto.getItem_count()); 
				jo.put("item_qty",bdto.getItem_qty());

				ja.put(jo);		
			}
			return ja.toString();	   
	   }
}
	



