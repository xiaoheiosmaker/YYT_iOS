
/* Header for class SecurityChain */

#ifndef _Included_SecurityChain_
#define _Included_SecurityChain_

#include <string>
/*
#ifdef __cplusplus
extern "C" {
#endif
*/
/*
 * Class:     SecurityChain
 * Method:    get_security_chain
 */
std::string get_security_chain(std::string security_key, std::string video_url, std::string time);
std::string get_phone_chain(std::string uniqueId, std::string appid, std::string localphone);
/*
#ifdef __cplusplus
}
#endif
*/
#endif
