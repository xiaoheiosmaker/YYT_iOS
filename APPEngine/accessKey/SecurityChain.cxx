

#include <stdio.h>
//#include <iostream>
#include "SecurityChain.h"
#include "md5.h"


std::string data_to_hex(const unsigned char *src, int s, int lowercase){
	int i;
	std::string rs;
	const char hex_table_uc[16] = { '0', '1', '2', '3',
		'4', '5', '6', '7',
		'8', '9', 'A', 'B',
		'C', 'D', 'E', 'F' };
	const char hex_table_lc[16] = { '0', '1', '2', '3',
		'4', '5', '6', '7',
		'8', '9', 'a', 'b',
		'c', 'd', 'e', 'f' };
	const char *hex_table = lowercase ? hex_table_lc : hex_table_uc;

	for(i = 0; i < s; i++) {
		rs.push_back(hex_table[src[i] >> 4]);
		rs.push_back(hex_table[src[i] & 0xF]);
	}

	return rs;
}
/*
JNIEXPORT jstring JNICALL Java_com_pro09_ui_SecurityChain_get_1security_1chain
  (JNIEnv * env, jobject obj, jstring key, jstring url, jstring time)
  {
	  std::string sc;
	  char* pKey = (char*) env->GetStringUTFChars(key, NULL);
	  std::string strKey = pKey;
	  char* pUrl = (char*) env->GetStringUTFChars(url, NULL);
	  std::string strUrl = pUrl;
	  char* pTime= (char*) env->GetStringUTFChars(time, NULL);
	  std::string strTime = pTime;
	  std::string xx = strKey;
	  xx += strUrl;
	  xx += strTime;
	  
	  // grnerate md5
	  unsigned char value[40] = {0};
	  unsigned char out[40] = {0};
	  ctx_md5 md5;
	  md5.update( (const unsigned char*)xx.c_str(), xx.length() );
	  md5.finish(value);
	  
	  // release 
	  env->ReleaseStringUTFChars(key, pKey);
	  env->ReleaseStringUTFChars(url, pUrl);
	  env->ReleaseStringUTFChars(time, pTime);
	  
	  // output
	  jstring output;
	  memcpy(out,data_to_hex((unsigned char*)value, 16, 1 ).data(), 32);
	  output = env->NewStringUTF((char*)out);
	  return output;
  }
*/
std::string get_security_chain(std::string security_key, std::string video_url, std::string time)
{
  unsigned char value[16];
  // input
  std::string input = "yinyuetai";
  input += video_url;
  input += time;
  
  // md5
  ctx_md5 md5;
  md5.update( (const unsigned char*)input.c_str(), input.length() );
  md5.finish(value);
  //  std::cout << data_to_hex((unsigned char*)value, 16, 1 ).substr(0,16) << std::endl;
  return data_to_hex((unsigned char*)value, 16, 1 ).substr(0,16);
}

std::string get_phone_chain(std::string uniqueId, std::string appid, std::string localphone)
{
  unsigned char chTemp = 0;
  unsigned char value[16];
  // key decrypt
  std::string key = "ows<z@B.,";
  std::string strPad;
  const char* pszUrl = key.c_str();
  for ( unsigned int i=0; i<key.length(); i++ )
  {
	chTemp = pszUrl[i] - key.length();
	strPad += chTemp;
  }
  
  std::string input = uniqueId;
  input += strPad;
  input += appid;
  input += localphone;
  
  // md5
  ctx_md5 md5;
  md5.update( (const unsigned char*)input.c_str(), input.length() );
  md5.finish(value);
  return data_to_hex((unsigned char*)value, 16, 1 );
}

