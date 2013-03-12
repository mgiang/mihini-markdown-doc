/**
 * @file devtree_v2.h  Device Management Tree Specification - Version 2
 *
 * This file defines the standard function APIs that must be exported by shared object
 * libraries that implement the standard Device Management Tree API, version 2.
 * Any such library MUST be called libdevtree.2.so and MUST implement the functions
 * specified in this file EXACTLY as they are specified.
 *  
 * Copyright (C) Sierra Wireless, Inc., 2012.
 */

#ifndef __DEVTREE_V2_H
#define __DEVTREE_V2_H

/* ==================================================================
 *  DATA TYPE DEFINITIONS
 * ================================================================== */

/**
 * Result codes.
 */
typedef enum
{
    DT2_RESULT_OK,                  /**< Success! */
    DT2_RESULT_TRUNCATED,           /**< The value could not fit in the buffer provided. */
    DT2_RESULT_DEVICE_NOT_FOUND,    /**< The device is not connected or is not working. */
    DT2_RESULT_WRONG_MODE,          /**< The device is in a mode that does not allow this operation. */
    DT2_RESULT_ERROR,               /**< The device reported an error. */
}
dt2_ResultCode_t;


/* ==================================================================
 *  ACCESSOR FUNCTION PROTOTYPES
 * ================================================================== */

/** String "Get" function prototype.
 * 
 * All "get" accessor functions for string type variables must conform to this prototype.
 * 
 * @return Result code.  Anything other than DT2_RESULT_OK indicates a failure, in which
 *         case the value buffer contents are undefined. 
 */
typedef dt2_ResultCode_t (* dt2_StringGetFunc_t)
(
    char*   valuePtr,       /**< Pointer to the buffer into which the value will be copied. */
    size_t  buffSize        /**< Size of the buffer, in bytes. */
);


/** Integer "Get" function prototype.
 * 
 * All "get" accessor functions for integer type variables must conform to this prototype.
 * 
 * @return Result code.  Anything other than DT2_RESULT_OK indicates a failure, in which
 *         case the value buffer contents are undefined. 
 */
typedef dt2_ResultCode_t (* dt2_IntegerGetFunc_t)
(
    int*    valuePtr        /**< Pointer to the buffer into which the value will be copied. */
);


/** Double-precision floating-point "Get" function prototype.
 * 
 * All "Get" accessor functions for "double" type variables must conform to this prototype.
 * 
 * @return Result code.  Anything other than DT2_RESULT_OK indicates a failure, in which
 *         case the value buffer contents are undefined. 
 */
typedef dt2_ResultCode_t (* dt2_DoubleGetFunc_t)
(
    double* valuePtr          /**< Pointer to the buffer into which the value will be copied. */
);


/** String "Set" function prototype.
 * 
 * All "set" accessor functions for string type variables must conform to this prototype.
 * 
 * @return Result code.  Anything other than DT2_RESULT_OK indicates a failure. 
 */
typedef dt2_ResultCode_t (* dt2_StringSetFunc_t)
(
    const char* stringPtr       /**< Pointer to the new value. */
);


/** Integer "Set" function prototype.
 * 
 * All "set" accessor functions for integer type variables must conform to this prototype.
 * 
 * @return Result code.  Anything other than DT2_RESULT_OK indicates a failure. 
 */
typedef dt2_ResultCode_t (* dt2_IntegerSetFunc_t)
(
    int    value        /**< The new value. */
);


/** Double-precision floating-point "Set" function prototype.
 * 
 * All "Set" accessor functions for "double" type variables must conform to this prototype.
 * 
 * @return Result code.  Anything other than DT2_RESULT_OK indicates a failure. 
 */
typedef dt2_ResultCode_t (* dt2_DoubleSetFunc_t)
(
    double  value       /**< The new value. */
);


/* ==================================================================
 *  VARIABLE ACCESSOR FUNCTION DECLARATIONS
 * ================================================================== */

/** Get Device ID.
 * 
 * This function is used to fetch the device ID that will be used to identify this
 * device to the Air Vantage server.
 * 
 * The device ID is a string of ANSI characters, usually (but not necessarily) the IMEI.
 * 
 * @return Result code.  Anything other than DT2_RESULT_OK indicates a failure, in which
 *         case the string buffer contents are undefined. 
 */
dt2_ResultCode_t dt2_GetDeviceId
(
    char*   stringPtr,      /**< Pointer to the buffer into which the string will be copied. */
    size_t  buffSize        /**< Size of the buffer, in bytes. */ 
);


/* ==================================================================
 *  system.cellular.*
 * ================================================================== */

/** Get APN Override.
 * 
 * This function is used to fetch the current APN override setting.  This is a writeable
 * string that can be used to override the default APN to be used by the device.
 * 
 * The APN is a string of ANSI characters.
 * 
 * @return Result code.  Anything other than DT2_RESULT_OK indicates a failure, in which
 *         case the string buffer contents are undefined. 
 */
dt2_ResultCode_t dt2_GetApnOverride
(
    char*   stringPtr,      /**< Pointer to the buffer into which the string will be copied. */
    size_t  buffSize        /**< Size of the buffer, in bytes. */ 
);


/** Set APN Override.
 * 
 * This function is used to set the current APN override setting.  This is a writeable
 * string that can be used to override the default APN to be used by the device.
 * 
 * The APN is a string of ANSI characters.
 * 
 * @return Result code.  Anything other than DT2_RESULT_OK indicates a failure. 
 */
dt2_ResultCode_t dt2_SetApnOverride
(
    const char* stringPtr       /**< Pointer to the new value. */
);


/** Get APN.
 * 
 * This function is used to fetch the current APN being used by the device.  This is a
 * read-only variable.
 * 
 * The APN is a string of ANSI characters.
 * 
 * @return Result code.  Anything other than DT2_RESULT_OK indicates a failure, in which
 *         case the string buffer contents are undefined.
 */
dt2_ResultCode_t dt2_GetApn
(
    char*   stringPtr,      /**< Pointer to the buffer into which the string will be copied. */
    size_t  buffSize        /**< Size of the buffer, in bytes. */ 
);


/** Get CDMA Link Operator.
 * 
 * This function is used to fetch the name of the current CDMA link operator, if any.
 * This is a read-only variable.
 * 
 * The operator name is a string of ANSI characters.
 * 
 * @return Result code.  Anything other than DT2_RESULT_OK indicates a failure, in which
 *         case the string buffer contents are undefined.
 */
dt2_ResultCode_t dt2_GetCdmaLinkOperator
(
    char*   stringPtr,      /**< Pointer to the buffer into which the string will be copied. */
    size_t  buffSize        /**< Size of the buffer, in bytes. */ 
);


/** Get GSM Link Operator.
 * 
 * This function is used to fetch the name of the current GSM link operator, if any.
 * This is a read-only variable.
 * 
 * The operator name is a string of ANSI characters.
 * 
 * @return Result code.  Anything other than DT2_RESULT_OK indicates a failure, in which
 *         case the string buffer contents are undefined.
 */
dt2_ResultCode_t dt2_GetGsmLinkOperator
(
    char*   stringPtr,      /**< Pointer to the buffer into which the string will be copied. */
    size_t  buffSize        /**< Size of the buffer, in bytes. */ 
);


/** Get IMEI.
 * 
 * This function is used to fetch the device's IMEI.  This is a read-only variable.
 * 
 * The IMEI is a string of ANSI characters.
 * 
 * @return Result code.  Anything other than DT2_RESULT_OK indicates a failure, in which
 *         case the string buffer contents are undefined.
 */
dt2_ResultCode_t dt2_GetImei
(
    char*   stringPtr,      /**< Pointer to the buffer into which the string will be copied. */
    size_t  buffSize        /**< Size of the buffer, in bytes. */ 
);


/** Roaming Status Codes.
 * 
 * These are the possible values of the "Roaming Status" variable.
 */
typedef enum
{
    DT2_ROAM_STATUS_NOT_ROAMING = 0,
    DT2_ROAM_STATUS_ROAMING = 1,
    DT2_ROAM_STATUS_INTERNATIONAL = 2,
}
dt2_RoamingStatus_t;


/** Get Roaming Status.
 * 
 * Fetches the current roaming status of the device.
 * 
 * @return Result code.  Anything other than DT2_RESULT_OK indicates a failure, in which
 *         case the value buffer contents are undefined. 
 */
dt2_ResultCode_t dt2_GetRoamStatus
(
    dt2_RoamingStatus_t* valuePtr  /**< Pointer to the buffer into which the value will be copied. */
);


/** Get RSSI.
 * 
 * Fetches the current cellular signal strength (RSSI).
 * 
 * The RSSI is a signed integer value from -150 to 0 dBm.
 * 
 * @return Result code.  Anything other than DT2_RESULT_OK indicates a failure, in which
 *         case the value buffer contents are undefined. 
 */
dt2_ResultCode_t dt2_GetRssi
(
    int*    valuePtr        /**< Pointer to the buffer into which the value will be copied. */
);

    
/* ==================================================================
 *  system.gps.*
 * ================================================================== */

/** Get Altitude.
 * 
 * This function is used to fetch the device's current altitude, if equipped with
 * a sensor that provides this data (such as GPS).  This is a read-only variable.
 * 
 * The altitude is reported in the form of a string of ANSI characters.
 * 
 * @return Result code.  Anything other than DT2_RESULT_OK indicates a failure, in which
 *         case the string buffer contents are undefined.
 */
dt2_ResultCode_t dt2_GetAltitude
(
    char*   stringPtr,      /**< Pointer to the buffer into which the string will be copied. */
    size_t  buffSize        /**< Size of the buffer, in bytes. */ 
);


/** Get Latitude.
 * 
 * This function is used to fetch the device's current latitude, if equipped with
 * a sensor that provides this data (such as GPS).  This is a read-only variable.
 * 
 * The latitude is reported in the form of a string of ANSI characters.
 * 
 * @return Result code.  Anything other than DT2_RESULT_OK indicates a failure, in which
 *         case the string buffer contents are undefined.
 */
dt2_ResultCode_t dt2_GetLatitude
(
    char*   stringPtr,      /**< Pointer to the buffer into which the string will be copied. */
    size_t  buffSize        /**< Size of the buffer, in bytes. */ 
);


/** Get Longitude.
 * 
 * This function is used to fetch the device's current longitude, if equipped with
 * a sensor that provides this data (such as GPS).  This is a read-only variable.
 * 
 * The longitude is reported in the form of a string of ANSI characters.
 * 
 * @return Result code.  Anything other than DT2_RESULT_OK indicates a failure, in which
 *         case the string buffer contents are undefined.
 */
dt2_ResultCode_t dt2_GetLongitude
(
    char*   stringPtr,      /**< Pointer to the buffer into which the string will be copied. */
    size_t  buffSize        /**< Size of the buffer, in bytes. */ 
);


#endif /* __DEVTREE_V2_H */
