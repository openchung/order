package com.lesson.controller;

import com.lesson.model.Menu;
import com.lesson.service.CategoryManager;
import com.lesson.service.MenuManager;
import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.io.UnsupportedEncodingException;

@Controller
public class OrderEntryControllor {
    @Autowired
    MenuManager menuManager;

    @Autowired
    CategoryManager categoryManager;

    Logger logger = Logger.getLogger(OrderEntryControllor.class);

    /**
     * 展示菜品
     *
     * @param model
     * @param mid     餐點id （查詢用）
     * @param cid     餐點分類id （查詢用）
     * @param request
     * @return
     */
    @RequestMapping(value = "/showMenus")
    public String showMenus(Model model,
                            @RequestParam(value = "mid", required = false) String mid,
                            @RequestParam(value = "cid", required = false) String cid,
                            @RequestParam(value = "useCookie", required = false) String useCookie,
                            HttpServletRequest request,
                            HttpServletResponse response) {
        logger.info("mid = " + mid);
        logger.info("cid = " + cid);
        logger.info("useCookie = " + useCookie);

        //判斷mid cid為空的情形
        if (mid == null || mid.equalsIgnoreCase("") || mid.equalsIgnoreCase("all")) {
            mid = "%";
        }
        if (cid == null || cid.equalsIgnoreCase("") || cid.equalsIgnoreCase("all")) {
            cid = "%";
        }

        HttpSession session = request.getSession();
        String sessionId = session.getId();
        model.addAttribute("menus", menuManager.getMenusByMidCid(mid, cid));
        session.setAttribute("categoryManager", categoryManager);



        //配置cookie
        if(useCookie != null && useCookie.equalsIgnoreCase("on")){
            int expire = 3600 * 24 * 30; //如果使用cookie，则将过期时间设为1个月
            logger.info("用戶選擇使用cookie，進入使用cookies的控制邏輯！");
            Cookie ckUseCookie = new Cookie("ckUseCookie","on");
            Cookie ckCid = new Cookie("ckCid",cid);
            ckUseCookie.setMaxAge(expire);
            ckCid.setMaxAge(expire);

            response.addCookie(ckUseCookie);
            response.addCookie(ckCid);
        }else{
            int expire = -1; //如果使用cookie，則將過期時間設為-1，控制該cookie立刻過期
            logger.info("用戶沒有選擇使用cookie，進入不使用cookies的控制邏輯！");
            Cookie ckUseCookie =new Cookie("ckUseCookie","");
            Cookie ckCid =new Cookie("ckCid","");
            ckUseCookie.setMaxAge(expire);
            ckCid.setMaxAge(expire);

            response.addCookie(ckUseCookie);
            response.addCookie(ckCid);
        }

        logger.info("Session Id = " + sessionId);
        return "jsp/menuList.jsp";
    }

    /**
     * 展示編輯餐點頁
     *
     * @param model
     * @param mid     餐點id
     * @param request
     * @return
     */
    @RequestMapping(value = "/editMenu/{mid}", method = RequestMethod.GET)
    public String editMenu(Model model,
                           @PathVariable String mid,
                           HttpServletRequest request) {
        logger.info("Start editMenu!");
        Menu menu = menuManager.getMenuByMid(mid);
        HttpSession session = request.getSession();

        model.addAttribute("menu", menu);
        session.setAttribute("categoryManager", categoryManager);
        return "jsp/menuEdit.jsp";
    }

    /**
     * 展示添加餐點頁
     *
     * @param model
     * @param request
     * @return
     */
    @RequestMapping(value = "/addMenu", method = RequestMethod.GET)
    public String addMenu(Model model, HttpServletRequest request) {
        logger.info("Start addMenu!");
        HttpSession session = request.getSession();

        session.setAttribute("categoryManager", categoryManager);
        return "jsp/menuAdd.jsp";
    }

    /**
     * 保存菜品 （新建或更新）
     *
     * @param model
     * @param request
     * @param mid     -1 代表新建餐點，其他代表更新餐點
     * @param cid     分類ID
     * @param mname   餐點名稱
     * @param price   餐點價格
     * @return
     * @throws UnsupportedEncodingException
     */

    @RequestMapping(value = "/saveMenu", method = RequestMethod.POST)
    public String saveMenu(Model model,
                           HttpServletRequest request,
                           @RequestParam(value = "mid", required = true) int mid,
                           @RequestParam(value = "new_cid", required = true) int cid,
                           @RequestParam(value = "mname", required = true) String mname,
                           @RequestParam(value = "price", required = true) float price) throws UnsupportedEncodingException {
        if (mname != null && !mname.equalsIgnoreCase("")) {
            mname = new String(mname.getBytes("ISO-8859-1"), "utf8");
            mname = String.format("test-%s",mname);
        }

        if (mid >= 1) {
            logger.info("保存餐點更新！");
            logger.info("Request Param: mid = " + mid);
            logger.info("Request Param: cid = " + cid);
            logger.info("Request Param: mname = " + mname);
            logger.info("Request Param: price = " + price);
            menuManager.updateMenuByMid(mid, cid, mname, price);
        } else if (mid == -1) {
            logger.info("添加新餐點！");
            logger.info("Request Param: cid = " + cid);
            logger.info("Request Param: mname = " + mname);
            logger.info("Request Param: price = " + price);
            menuManager.addMenu(cid, mname, price);
        } else {
            logger.error("出錯了，mid 不正確！");
        }

        HttpSession session = request.getSession();
        model.addAttribute("menus", menuManager.getAllMenus());
        session.setAttribute("categoryManager", categoryManager);
        return "jsp/menuList.jsp";
    }

    /**
     * 删除餐點
     *
     * @param model
     * @param mid     餐點id
     * @param request
     * @return
     */
    @RequestMapping(value = "/delete/{mid}", method = RequestMethod.GET) //按照ID展示
    public String deleteMenu(Model model,
                             @PathVariable int mid,
                             HttpServletRequest request,
                             HttpServletResponse response) {
        menuManager.deleteMenuByMid(mid); //删除對應menu

        HttpSession session = request.getSession();
        model.addAttribute("menus", menuManager.getAllMenus());
        session.setAttribute("categoryManager", categoryManager);

        return "/showMenus";
    }

    /**
     * 展示所有餐點分類
     *
     * @param model
     * @return
     */
    @RequestMapping(value = "/showCategories")
    public String showCategories(Model model) {
        model.addAttribute("categories", categoryManager.getAllCategories());
        return "jsp/categoryList.jsp";
    }

    /**
     * 展示添加餐點分類頁面
     *
     * @param model
     * @return
     */
    @RequestMapping(value = "/addCategory", method = RequestMethod.GET)
    public String addCategory(Model model) {
        logger.info("Start addCategory!");
        return "jsp/categoryAdd.jsp";
    }

    /**
     * 修改餐點分類
     *
     * @param model
     * @param cid   餐點分類id
     * @return
     */
    @RequestMapping(value = "/editCategory/{cid}")
    public String editCategory(Model model, @PathVariable int cid) {
        model.addAttribute("category", categoryManager.getCategoryById(cid));
        return "jsp/categoryEdit.jsp";
    }

    /**
     * 保存餐點分類
     *
     * @param model
     * @param cid   餐點分類id
     * @param cname 餐點分類名稱
     * @return
     * @throws UnsupportedEncodingException
     */
    @RequestMapping(value = "/saveCategory", method = RequestMethod.POST)
    public String saveCategory(Model model,
                               @RequestParam(value = "cid", required = true) int cid,
                               @RequestParam(value = "cname", required = true) String cname) throws UnsupportedEncodingException {
        if (cname != null && !cname.equalsIgnoreCase("")) {
            cname = new String(cname.getBytes("ISO-8859-1"), "utf8");
        }

        if (cid >= 1) {
            logger.info("更新保存餐點分類！");
            logger.info("cid = " + cid);
            logger.info("cname = " + cname);
            categoryManager.updateCategoryById(cid, cname);
        } else if (cid == -1) {
            logger.info("添加新餐點分類！");
            logger.info("cname = " + cname);
            categoryManager.addCategory(cname);
        } else {
            logger.info("出錯了，id 不正確！");
        }
        model.addAttribute("categories", categoryManager.getAllCategories());
        return "jsp/categoryList.jsp";
    }

    /**
     * 删除餐點分類
     *
     * @param model
     * @param cid   餐點分類id
     * @return
     */
    @RequestMapping(value = "/deleteCategory/{cid}")
    public String deleteCategoryById(Model model,
                                     @PathVariable int cid,
                                     HttpServletRequest request) {
        try {
            categoryManager.deleteCategoryById(cid);
        } catch (Exception ex) {
            String errMsg = ex.getMessage();
            logger.info("發生錯誤，無法刪除！");
            logger.info(errMsg);
            if (errMsg.contains("MySQLIntegrityConstraintViolationException")) {
                logger.error("存在依賴，不能刪除該值");
                String cname = categoryManager.getCategoryById(cid).getCname();
                HttpSession session = request.getSession();
                session.setAttribute("errMsg", "出錯啦：\"" + cname + "\"下仍有餐點，不能刪除該分類！");
            }
        }
        model.addAttribute("categories", categoryManager.getAllCategories());
        return "jsp/categoryList.jsp";
    }

}
