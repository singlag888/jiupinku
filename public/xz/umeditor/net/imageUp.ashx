<%@ WebHandler Language="C#" Class="imageUp" %>
<%@ Assembly Src="Uploader.cs" %>

using System;
using System.Web;
using System.IO;
using System.Collections;
using System.Collections.Generic;

public class imageUp : IHttpHandler
{

    public void ProcessRequest(HttpContext context)
    {
        context.Response.ContentEncoding = System.Text.Encoding.UTF8;
        //�ϴ�����
        string pathbase = "upload/";                                                          //����·��
        int size = 10;                     //�ļ���С����,��λmb                                                                                   //�ļ���С���ƣ���λKB
        string[] filetype = { ".gif", ".png", ".jpg", ".jpeg", ".bmp" };                    //�ļ�������ʽ

        string callback = context.Request["callback"];
        string editorId = context.Request["editorid"];

        //�ϴ�ͼƬ
        Hashtable info;
        Uploader up = new Uploader();
        info = up.upFile(context, pathbase, filetype, size); //��ȡ�ϴ�״̬
        string json = BuildJson(info);

        context.Response.ContentType = "text/html";
        if (callback != null)
        {
            context.Response.Write(String.Format("<script>{0}(JSON.parse(\"{1}\"));</script>", callback, json));
        }
        else
        {
            context.Response.Write(json);
        }
    }

    public bool IsReusable
    {
        get
        {
            return false;
        }
    }

    private string BuildJson(Hashtable info)
    {
        List<string> fields = new List<string>();
        string[] keys = new string[] { "originalName", "name", "url", "size", "state", "type" };
        for (int i = 0; i < keys.Length; i++)
        {
            fields.Add(String.Format("\"{0}\": \"{1}\"", keys[i], info[keys[i]]));
        }
        return "{" + String.Join(",", fields) + "}";
    }

}