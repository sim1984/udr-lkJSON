/******************************************************************************/
/***                            Package headers                             ***/
/******************************************************************************/

CREATE DOMAIN TY$POINTER AS CHAR(8) CHARACTER SET OCTETS COLLATE OCTETS;

SET TERM ^ ;

CREATE OR ALTER PACKAGE JS$BASE
AS
BEGIN
  /* TlkJSONbase = class
     TlkJSONtypes =
       (jsBase, jsNumber, jsString, jsBoolean, jsNull, jsList, jsObject);
        0       1         2         3          4       5       6
  */
  FUNCTION Dispose(Self TY$POINTER) RETURNS SMALLINT; /* 0 - succes */

  FUNCTION Field(
      Self TY$POINTER,
      /* -- */ Name VARCHAR(256) CHARACTER SET NONE NOT NULL 
      -- utf8 Name VARCHAR(64) CHARACTER SET UTF8 NOT NULL
    ) RETURNS TY$POINTER; /* js$Base, js$Meth (jsList, jsObject) */

  FUNCTION Count_(Self TY$POINTER) RETURNS INTEGER;

  FUNCTION Parent(Self TY$POINTER) RETURNS TY$POINTER;
  FUNCTION Child(Self TY$POINTER, Idx INTEGER NOT NULL, Obj TY$POINTER = NULL /* Get */) RETURNS TY$POINTER;

  FUNCTION Value_(
      Self TY$POINTER,
      /* -- */ Val VARCHAR(32765) CHARACTER SET NONE = NULL /* Get */
      -- utf8 Val VARCHAR(8191) CHARACTER SET UTF8 = NULL /* Get */
    /* -- */ ) RETURNS VARCHAR(32765) CHARACTER SET NONE;
    -- utf8 ) RETURNS VARCHAR(8191) CHARACTER SET UTF8;

  FUNCTION WideValue_(Self TY$POINTER, WVal BLOB SUB_TYPE TEXT = NULL /* Get */) RETURNS BLOB SUB_TYPE TEXT;

  FUNCTION SelfType(Self TY$POINTER = NULL /* NULL - class function */) RETURNS SMALLINT;
  FUNCTION SelfTypeName(Self TY$POINTER = NULL /* NULL - class function */)
    /* -- */ RETURNS VARCHAR(64) CHARACTER SET NONE;
    -- utf8 RETURNS VARCHAR(16) CHARACTER SET UTF8;

END^


CREATE OR ALTER PACKAGE JS$BOOL
AS
BEGIN
  /* TlkJSONbase = class
     TlkJSONboolean = class(TlkJSONbase)
  */
  FUNCTION Parent(Self TY$POINTER) RETURNS TY$POINTER;

  FUNCTION Value_(Self TY$POINTER, Bool BOOLEAN = NULL /* Get */) RETURNS BOOLEAN;

  FUNCTION Generate(Self TY$POINTER = NULL /* NULL - class function */, Bool BOOLEAN NOT NULL = TRUE) RETURNS TY$POINTER;

  FUNCTION SelfType(Self TY$POINTER = NULL /* NULL - class function */) RETURNS SMALLINT;
  FUNCTION SelfTypeName(Self TY$POINTER = NULL /* NULL - class function */)
    /* -- */ RETURNS VARCHAR(64) CHARACTER SET NONE;
    -- utf8 RETURNS VARCHAR(16) CHARACTER SET UTF8;

END^


CREATE OR ALTER PACKAGE JS$CUSTLIST
AS
BEGIN
  /* TlkJSONbase = class
     TlkJSONcustomlist = class(TlkJSONbase)
  */
  FUNCTION Field(
      Self TY$POINTER,
      /* -- */ Name VARCHAR(256) CHARACTER SET NONE NOT NULL /* 0.. = Idx */
      -- utf8 Name VARCHAR(64) CHARACTER SET UTF8 NOT NULL /* 0.. = Idx */
    ) RETURNS TY$POINTER; /* js$Meth */
  
  FUNCTION Count_(Self TY$POINTER) RETURNS INTEGER;

  FUNCTION Parent(Self TY$POINTER) RETURNS TY$POINTER;
  FUNCTION Child(Self TY$POINTER, Idx INTEGER NOT NULL, Obj TY$POINTER = NULL /* Get */) RETURNS TY$POINTER;

  FUNCTION GetBoolean(Self TY$POINTER, Idx INTEGER NOT NULL) RETURNS BOOLEAN;
  FUNCTION GetDouble(Self TY$POINTER, Idx INTEGER NOT NULL) RETURNS DOUBLE PRECISION;
  FUNCTION GetInteger(Self TY$POINTER, Idx INTEGER NOT NULL) RETURNS INTEGER;
  FUNCTION GetString(Self TY$POINTER, Idx INTEGER NOT NULL)
    /* -- */ RETURNS VARCHAR(32765) CHARACTER SET NONE;
    -- utf8 RETURNS VARCHAR(8191) CHARACTER SET UTF8;
  FUNCTION GetWideString(Self TY$POINTER, Idx INTEGER NOT NULL) RETURNS BLOB SUB_TYPE TEXT;

  PROCEDURE ForEach (
      Self TY$POINTER
    ) RETURNS (
      Idx INTEGER,
      /* -- */ Name VARCHAR(256) CHARACTER SET NONE,
      -- utf8 Name VARCHAR(64) CHARACTER SET UTF8,
      Obj TY$POINTER /* js$Base */
    );

END^


CREATE OR ALTER PACKAGE JS$FUNC
AS
BEGIN

  FUNCTION ParseText(Text BLOB SUB_TYPE TEXT, Conv BOOLEAN NOT NULL = FALSE) RETURNS TY$POINTER;
  FUNCTION ParseString(
      /* -- */ String VARCHAR(32765) CHARACTER SET NONE,
      -- utf8 String VARCHAR(8191) CHARACTER SET UTF8,
      Conv BOOLEAN NOT NULL = FALSE
    ) RETURNS TY$POINTER;

  FUNCTION GenerateText(Obj TY$POINTER, Conv BOOLEAN NOT NULL = FALSE) RETURNS BLOB SUB_TYPE TEXT;
  FUNCTION GenerateString(Obj TY$POINTER, Conv BOOLEAN NOT NULL = FALSE)
    /* -- */ RETURNS VARCHAR(32765) CHARACTER SET NONE;
    -- utf8 RETURNS VARCHAR(8191) CHARACTER SET UTF8;

  FUNCTION ReadableText(Obj TY$POINTER, Level INTEGER NOT NULL = 0, Conv BOOLEAN NOT NULL = FALSE)
    RETURNS BLOB SUB_TYPE TEXT;

END^


CREATE OR ALTER PACKAGE JS$LIST
AS
BEGIN
  /* TlkJSONbase = class
     TlkJSONcustomlist = class(TlkJSONbase)
     TlkJSONlist = class(TlkJSONcustomlist)
  */
  FUNCTION Field(
      Self TY$POINTER,
      /* -- */ Name VARCHAR(256) CHARACTER SET NONE NOT NULL /* 0.. = Idx */
      -- utf8 Name VARCHAR(64) CHARACTER SET UTF8 NOT NULL /* 0.. = Idx */
    ) RETURNS TY$POINTER; /* js$Meth */

  FUNCTION IndexOfObject(Self TY$POINTER, Obj TY$POINTER NOT NULL) RETURNS INTEGER;

  FUNCTION Count_(Self TY$POINTER) RETURNS INTEGER;
  
  FUNCTION Parent(Self TY$POINTER) RETURNS TY$POINTER;
  FUNCTION Child(Self TY$POINTER, Idx INTEGER NOT NULL, Obj TY$POINTER = NULL /* Get */) RETURNS TY$POINTER;

  FUNCTION Add_(Self TY$POINTER, Obj TY$POINTER NOT NULL) RETURNS INTEGER;
  FUNCTION AddBoolean(Self TY$POINTER, Bool BOOLEAN) RETURNS INTEGER;
  FUNCTION AddDouble(Self TY$POINTER, Dbl DOUBLE PRECISION) RETURNS INTEGER;
  FUNCTION AddInteger(Self TY$POINTER, Int_ INTEGER) RETURNS INTEGER;
  FUNCTION AddString(
      Self TY$POINTER,
      /* -- */ Str VARCHAR(32765) CHARACTER SET NONE
      -- utf8 Str VARCHAR(8191) CHARACTER SET UTF8
    ) RETURNS INTEGER;
  FUNCTION AddWideString(Self TY$POINTER, WStr BLOB SUB_TYPE TEXT) RETURNS INTEGER;

  FUNCTION Delete_(Self TY$POINTER, Idx INTEGER NOT NULL) RETURNS SMALLINT;

  PROCEDURE ForEach(
      Self TY$POINTER
    ) RETURNS (
      Idx INTEGER,
      /* -- */ Name VARCHAR(256) CHARACTER SET NONE,
      -- utf8 Name VARCHAR(256) CHARACTER SET UTF8,
      Obj TY$POINTER /* js$Base */
    );

  FUNCTION Generate(Self TY$POINTER = NULL /* NULL - class function */) RETURNS TY$POINTER;

  FUNCTION SelfType(Self TY$POINTER = NULL /* NULL - class function */) RETURNS SMALLINT;
  FUNCTION SelfTypeName(Self TY$POINTER = NULL /* NULL - class function */)
    /* -- */ RETURNS VARCHAR(64) CHARACTER SET NONE;
    -- utf8 RETURNS VARCHAR(16) CHARACTER SET UTF8;

END^


CREATE OR ALTER PACKAGE JS$METH
AS
BEGIN
  /* TlkJSONbase = class
     TlkJSONobjectmethod = class(TlkJSONbase)
  */
  FUNCTION Parent(Self TY$POINTER) RETURNS TY$POINTER; /* always NULL, call ObjValue.Parent */

  FUNCTION MethodObjValue(Self TY$POINTER) RETURNS TY$POINTER;
  FUNCTION MethodName(
      Self TY$POINTER,
      /* -- */ Name VARCHAR(256) CHARACTER SET NONE = NULL /* Get */
      -- utf8 Name VARCHAR(64) CHARACTER SET UTF8 = NULL /* Get */
    /* -- */ ) RETURNS VARCHAR(256) CHARACTER SET NONE;
    -- utf8) RETURNS VARCHAR(64) CHARACTER SET UTF8;

  FUNCTION MethodGenerate(
      Self TY$POINTER,
      /* -- */ Name VARCHAR(256) CHARACTER SET NONE NOT NULL,
      -- utf8 Name VARCHAR(64) CHARACTER SET UTF8 NOT NULL,
      Obj TY$POINTER NOT NULL /* js$Base */
    ) RETURNS TY$POINTER /* js$Meth */;

END^


CREATE OR ALTER PACKAGE JS$NULL
AS
BEGIN
  /* TlkJSONbase = class
     TlkJSONnull = class(TlkJSONbase)
  */
  FUNCTION Parent(Self TY$POINTER) RETURNS TY$POINTER;

  FUNCTION Value_(Self TY$POINTER) RETURNS SMALLINT;

  FUNCTION Generate(Self TY$POINTER = NULL /* NULL - class function */) RETURNS TY$POINTER;

  FUNCTION SelfType(Self TY$POINTER = NULL /* NULL - class function */) RETURNS SMALLINT;
  FUNCTION SelfTypeName(Self TY$POINTER = NULL /* NULL - class function */)
    /* -- */ RETURNS VARCHAR(64) CHARACTER SET NONE;
    -- utf8 RETURNS VARCHAR(16) CHARACTER SET UTF8;

END^


CREATE OR ALTER PACKAGE JS$NUM
AS
BEGIN
  /* TlkJSONbase = class
     TlkJSONnumber = class(TlkJSONbase)
  */
  FUNCTION Parent(Self TY$POINTER) RETURNS TY$POINTER;

  FUNCTION Value_(Self TY$POINTER, Num DOUBLE PRECISION = NULL /* Get */) RETURNS DOUBLE PRECISION;

  FUNCTION Generate(Self TY$POINTER = NULL /* NULL - class function */, Num DOUBLE PRECISION NOT NULL = 0) RETURNS TY$POINTER;

  FUNCTION SelfType(Self TY$POINTER = NULL /* NULL - class function */) RETURNS SMALLINT;
  FUNCTION SelfTypeName(Self TY$POINTER = NULL /* NULL - class function */)
    /* -- */ RETURNS VARCHAR(64) CHARACTER SET NONE;
    -- utf8 RETURNS VARCHAR(16) CHARACTER SET UTF8;

END^


CREATE OR ALTER PACKAGE JS$OBJ
AS
BEGIN
  /* TlkJSONbase = class
     TlkJSONcustomlist = class(TlkJSONbase)
     TlkJSONobject = class(TlkJSONcustomlist)
  */
  FUNCTION New_(UseHash BOOLEAN NOT NULL = TRUE) RETURNS TY$POINTER;
  FUNCTION Dispose(Self TY$POINTER) RETURNS SMALLINT; /* 0 - succes */

  FUNCTION Field(
      Self TY$POINTER,
      /* -- */ Name VARCHAR(256) CHARACTER SET NONE NOT NULL,
      -- utf8 Name VARCHAR(64) CHARACTER SET UTF8 NOT NULL,
      Obj TY$POINTER = NULL /* Get */
    ) RETURNS TY$POINTER;
  FUNCTION FieldByIndex(Self TY$POINTER, Idx INTEGER NOT NULL, Obj TY$POINTER = NULL /* Get */) RETURNS TY$POINTER;

  FUNCTION NameOf(Self TY$POINTER, Idx INTEGER NOT NULL)
    /*  */ RETURNS VARCHAR(256) CHARACTER SET NONE NOT NULL;
    -- utf8 RETURNS VARCHAR(64) CHARACTER SET UTF8 NOT NULL;
  FUNCTION IndexOfName(
      Self TY$POINTER,
      /* -- */ Name VARCHAR(256) CHARACTER SET NONE NOT NULL
      -- utf8 Name VARCHAR(64) CHARACTER SET UTF8 NOT NULL
    ) RETURNS INTEGER;
  FUNCTION IndexOfObject(Self TY$POINTER, Obj TY$POINTER NOT NULL) RETURNS INTEGER;
  
  FUNCTION Count_(Self TY$POINTER) RETURNS INTEGER;

  FUNCTION Parent(Self TY$POINTER) RETURNS TY$POINTER;
  FUNCTION Child(Self TY$POINTER, Idx INTEGER NOT NULL, Obj TY$POINTER = NULL /* Get */) RETURNS TY$POINTER;

  FUNCTION Add_(
      Self TY$POINTER,
      /* -- */ Name VARCHAR(256) CHARACTER SET NONE NOT NULL,
      -- utf8 Name VARCHAR(64) CHARACTER SET UTF8 NOT NULL,
      Obj TY$POINTER NOT NULL
    ) RETURNS INTEGER;

  FUNCTION AddBoolean(
      Self TY$POINTER,
      /* -- */ Name VARCHAR(256) CHARACTER SET NONE NOT NULL,
      -- utf8 Name VARCHAR(64) CHARACTER SET UTF8 NOT NULL,
      Bool BOOLEAN
    ) RETURNS INTEGER;

  FUNCTION AddDouble(
      Self TY$POINTER,
      /* -- */ Name VARCHAR(256) CHARACTER SET NONE NOT NULL,
      -- utf8 Name VARCHAR(64) CHARACTER SET UTF8 NOT NULL,
      Dbl DOUBLE PRECISION
    ) RETURNS INTEGER;

  FUNCTION AddInteger(
      Self TY$POINTER,
      /* -- */ Name VARCHAR(256) CHARACTER SET NONE NOT NULL,
      -- utf8 Name VARCHAR(64) CHARACTER SET UTF8 NOT NULL,
      Int_ INTEGER
    ) RETURNS INTEGER;

  FUNCTION AddString(
      Self TY$POINTER,
      /* -- */ Name VARCHAR(256) CHARACTER SET NONE NOT NULL,
      -- utf8 Name VARCHAR(64) CHARACTER SET UTF8 NOT NULL,
      /*  */ Str VARCHAR(32765) CHARACTER SET NONE
      -- utf8 Str VARCHAR(8191) CHARACTER SET UTF8
    ) RETURNS INTEGER;

  FUNCTION AddWideString(
      Self TY$POINTER,
      /* -- */ Name VARCHAR(256) CHARACTER SET NONE NOT NULL,
      -- utf8 Name VARCHAR(64) CHARACTER SET UTF8 NOT NULL,
      WStr BLOB SUB_TYPE TEXT
    ) RETURNS INTEGER;

  FUNCTION GetBoolean(Self TY$POINTER, Idx INTEGER NOT NULL) RETURNS BOOLEAN;
  FUNCTION GetDouble(Self TY$POINTER, Idx INTEGER NOT NULL) RETURNS DOUBLE PRECISION;
  FUNCTION GetInteger(Self TY$POINTER, Idx INTEGER NOT NULL) RETURNS INTEGER;
  FUNCTION GetString(Self TY$POINTER, Idx INTEGER NOT NULL) RETURNS VARCHAR(32765);
  FUNCTION GetWideString(Self TY$POINTER, Idx INTEGER NOT NULL) RETURNS BLOB SUB_TYPE TEXT;

  FUNCTION GetBooleanByName(
      Self TY$POINTER,
      /* -- */ Name VARCHAR(256) CHARACTER SET NONE NOT NULL
      -- utf8 Name VARCHAR(64) CHARACTER SET UTF8 NOT NULL
    ) RETURNS BOOLEAN;

  FUNCTION GetDoubleByName(
      Self TY$POINTER,
      /* -- */ Name VARCHAR(256) CHARACTER SET NONE NOT NULL
      -- utf8 Name VARCHAR(64) CHARACTER SET UTF8 NOT NULL
    ) RETURNS DOUBLE PRECISION;

  FUNCTION GetIntegerByName(
      Self TY$POINTER,
      /* -- */ Name VARCHAR(256) CHARACTER SET NONE NOT NULL
      -- utf8 Name VARCHAR(64) CHARACTER SET UTF8 NOT NULL
    ) RETURNS INTEGER;

  FUNCTION GetStringByName(
      Self TY$POINTER,
      /* -- */ Name VARCHAR(256) CHARACTER SET NONE NOT NULL
      -- utf8 Name VARCHAR(64) CHARACTER SET UTF8 NOT NULL
    /*  */ ) RETURNS VARCHAR(32765) CHARACTER SET NONE;
    -- utf8 ) RETURNS VARCHAR(8191) CHARACTER SET UTF8;

  FUNCTION GetWideStringByName(
      Self TY$POINTER,
      /* -- */ Name VARCHAR(256) CHARACTER SET NONE NOT NULL
      -- utf8 Name VARCHAR(64) CHARACTER SET UTF8 NOT NULL
    ) RETURNS BLOB SUB_TYPE TEXT;

  FUNCTION Delete_(Self TY$POINTER, Idx INTEGER NOT NULL) RETURNS SMALLINT;
  
  PROCEDURE ForEach(
      Self TY$POINTER
    ) RETURNS (
      Idx INTEGER,
      /* -- */ Name VARCHAR(256) CHARACTER SET NONE,
      -- utf8 Name VARCHAR(64) CHARACTER SET UTF8,
      Obj TY$POINTER /* js$Base */
    );

  FUNCTION Generate(Self TY$POINTER = NULL /* NULL - class function */, UseHash BOOLEAN NOT NULL = TRUE) RETURNS TY$POINTER;

  FUNCTION SelfType(Self TY$POINTER = NULL /* NULL - class function */) RETURNS SMALLINT;
  FUNCTION SelfTypeName(Self TY$POINTER)
    /* -- */ RETURNS VARCHAR(64) CHARACTER SET NONE;
    -- utf8 RETURNS VARCHAR(16) CHARACTER SET UTF8;

END^


CREATE OR ALTER PACKAGE JS$PTR
AS
BEGIN
  FUNCTION New_(
      UsePtr CHAR(3) CHARACTER SET NONE NOT NULL /* Tra - Transaction, Att - Attachment */,
      UseHash BOOLEAN NOT NULL = TRUE
    ) RETURNS TY$POINTER;
  FUNCTION Dispose(UsePtr CHAR(3) CHARACTER SET NONE NOT NULL) RETURNS SMALLINT;

  FUNCTION Tra RETURNS TY$POINTER;
  FUNCTION Att RETURNS TY$POINTER;
  
  FUNCTION isNull(jsPtr TY$POINTER) RETURNS BOOLEAN;  
END^


CREATE OR ALTER PACKAGE JS$STR
AS
BEGIN
  /* TlkJSONbase = class
     TlkJSONstring = class(TlkJSONbase)
  */
  FUNCTION Parent(Self TY$POINTER) RETURNS TY$POINTER;

  FUNCTION Value_(
      Self TY$POINTER,
      /*  */ Str VARCHAR(32765) CHARACTER SET NONE = NULL /* Get */
      -- utf8 Str VARCHAR(8191) CHARACTER SET UTF8 = NULL /* Get */
    /* -- */ ) RETURNS VARCHAR(32765) CHARACTER SET NONE;
    -- utf8 ) RETURNS VARCHAR(8191) CHARACTER SET UTF8;

  FUNCTION WideValue_(Self TY$POINTER, WStr BLOB SUB_TYPE TEXT = NULL /* Get */) RETURNS BLOB SUB_TYPE TEXT;

  FUNCTION Generate(
      Self TY$POINTER = NULL /* NULL - class function */,
      /*  */ Str VARCHAR(32765) CHARACTER SET NONE NOT NULL = '' /* Get */
      -- utf8 Str VARCHAR(8191) CHARACTER SET UTF8 NOT NULL = '' /* Get */
  ) RETURNS TY$POINTER;
  FUNCTION WideGenerate(Self TY$POINTER = NULL /* NULL - class function */, WStr BLOB SUB_TYPE TEXT = '') RETURNS TY$POINTER;

  FUNCTION SelfType(Self TY$POINTER = NULL /* NULL - class function */) RETURNS SMALLINT;
  FUNCTION SelfTypeName(Self TY$POINTER = NULL /* NULL - class function */)
    /* -- */ RETURNS VARCHAR(64) CHARACTER SET NONE;
    -- utf8 RETURNS VARCHAR(16) CHARACTER SET UTF8;

END^



SET TERM ; ^



/******************************************************************************/
/***                            Package headers                             ***/
/******************************************************************************/



SET TERM ^ ;


SET TERM ; ^



/******************************************************************************/
/***                             Package bodies                             ***/
/******************************************************************************/



SET TERM ^ ;

RECREATE PACKAGE BODY JS$BASE
AS
BEGIN

  FUNCTION Dispose(Self TY$POINTER) RETURNS SMALLINT
    EXTERNAL NAME 'lkjson!BaseDispose'
    ENGINE UDR;

  FUNCTION Field(
      Self TY$POINTER,
      /* -- */ Name VARCHAR(256) CHARACTER SET NONE NOT NULL
      -- utf8 Name VARCHAR(64) CHARACTER SET UTF8 NOT NULL
    ) RETURNS TY$POINTER
    EXTERNAL NAME 'lkjson!BaseField'
    ENGINE UDR;

  FUNCTION Count_(Self TY$POINTER) RETURNS INTEGER
    EXTERNAL NAME 'lkjson!BaseCount'
    ENGINE UDR;

  FUNCTION Parent(Self TY$POINTER) RETURNS TY$POINTER
    EXTERNAL NAME 'lkjson!BaseParent'
    ENGINE UDR;

  FUNCTION Child(Self TY$POINTER, Idx INTEGER NOT NULL, Obj TY$POINTER) RETURNS TY$POINTER
    EXTERNAL NAME 'lkjson!BaseChild'
    ENGINE UDR;

  FUNCTION Value_(
      Self TY$POINTER,
      /* -- */ Val VARCHAR(32765) CHARACTER SET NONE
      -- utf8 Val VARCHAR(8191) CHARACTER SET UTF8
    /* -- */ ) RETURNS VARCHAR(32765) CHARACTER SET NONE
    -- utf8 ) RETURNS VARCHAR(8191) CHARACTER SET UTF8
    EXTERNAL NAME 'lkjson!BaseValue'
    ENGINE UDR;

  FUNCTION WideValue_(Self TY$POINTER, WVal BLOB SUB_TYPE TEXT) RETURNS BLOB SUB_TYPE TEXT
    EXTERNAL NAME 'lkjson!BaseWideValue'
    ENGINE UDR;

  FUNCTION SelfType(Self TY$POINTER) RETURNS SMALLINT
    EXTERNAL NAME 'lkjson!BaseSelfType'
    ENGINE UDR;

  FUNCTION SelfTypeName(Self TY$POINTER)
    /* -- */ RETURNS VARCHAR(64) CHARACTER SET NONE
    -- utf8 RETURNS VARCHAR(16) CHARACTER SET UTF8
    EXTERNAL NAME 'lkjson!BaseSelfTypeName'
    ENGINE UDR;

END^


RECREATE PACKAGE BODY JS$BOOL
AS
BEGIN

  FUNCTION Parent(Self TY$POINTER) RETURNS TY$POINTER
  AS
  BEGIN
    RETURN js$Base.Parent(Self);
  END

  FUNCTION Value_(Self TY$POINTER, Bool BOOLEAN) RETURNS BOOLEAN
    EXTERNAL NAME 'lkjson!BooleanValue'
    ENGINE UDR;

  FUNCTION Generate(Self TY$POINTER, Bool BOOLEAN NOT NULL) RETURNS TY$POINTER
    EXTERNAL NAME 'lkjson!BooleanGenerate'
    ENGINE UDR;

  FUNCTION SelfType(Self TY$POINTER) RETURNS SMALLINT
    EXTERNAL NAME 'lkjson!BooleanSelfType'
    ENGINE UDR;

  FUNCTION SelfTypeName(Self TY$POINTER)
    /* -- */ RETURNS VARCHAR(64) CHARACTER SET NONE
    -- utf8 RETURNS VARCHAR(16) CHARACTER SET UTF8
    EXTERNAL NAME 'lkjson!BooleanSelfTypeName'
    ENGINE UDR;

END^


RECREATE PACKAGE BODY JS$CUSTLIST
AS
BEGIN

  FUNCTION Field(
      Self TY$POINTER,
      /* -- */ Name VARCHAR(256) CHARACTER SET NONE NOT NULL
      -- utf8 Name VARCHAR(64) CHARACTER SET UTF8 NOT NULL
    ) RETURNS TY$POINTER
  AS
  BEGIN
    RETURN js$Base.Field(Self, Name);
  END

  FUNCTION Count_(Self TY$POINTER) RETURNS INTEGER
  AS
  BEGIN
    RETURN js$Base.Count_(Self);
  END

  FUNCTION Parent(Self TY$POINTER) RETURNS TY$POINTER
  AS
  BEGIN
    RETURN js$Base.Parent(Self);
  END

  FUNCTION Child(Self TY$POINTER, Idx INTEGER NOT NULL, Obj TY$POINTER) RETURNS TY$POINTER
  AS
  BEGIN
    RETURN js$Base.Child(Self, Idx, Obj);
  END

  FUNCTION GetBoolean(Self TY$POINTER, Idx INTEGER NOT NULL) RETURNS BOOLEAN
    EXTERNAL NAME 'lkjson!CustomListGetBoolean'
    ENGINE UDR;

  FUNCTION GetDouble(Self TY$POINTER, Idx INTEGER NOT NULL) RETURNS DOUBLE PRECISION
    EXTERNAL NAME 'lkjson!CustomListGetDouble'
    ENGINE UDR;

  FUNCTION GetInteger(Self TY$POINTER, Idx INTEGER NOT NULL) RETURNS INTEGER
    EXTERNAL NAME 'lkjson!CustomListGetInteger'
    ENGINE UDR;

  FUNCTION GetString(Self TY$POINTER, Idx INTEGER NOT NULL)
    /* -- */ RETURNS VARCHAR(32765) CHARACTER SET NONE
    -- UTF RETURNS VARCHAR(8191) CHARACTER SET UTF8
    EXTERNAL NAME 'lkjson!CustomListGetString'
    ENGINE UDR;

  FUNCTION GetWideString(Self TY$POINTER, Idx INTEGER NOT NULL) RETURNS BLOB SUB_TYPE TEXT
    EXTERNAL NAME 'lkjson!CustomListGetWideString'
    ENGINE UDR;
    
  PROCEDURE ForEach (
      Self TY$POINTER
    ) RETURNS (
      Idx INTEGER,
      /* -- */ Name VARCHAR(256) CHARACTER SET NONE,
      -- utf8 Name VARCHAR(64) CHARACTER SET UTF8,
      Obj TY$POINTER
    )
  AS
    DECLARE Count_ INTEGER;
  BEGIN
    Idx = 0;
    Count_ = Count_(Self);
    WHILE (Idx < Count_) DO
    BEGIN
      Name = CAST(Idx AS VARCHAR(128));
      Obj = Child(Self, Idx);
      SUSPEND;
      Idx = Idx + 1;
    END 
  END

END^


RECREATE PACKAGE BODY JS$FUNC
AS
BEGIN

  FUNCTION ParseText(Text BLOB SUB_TYPE TEXT, Conv BOOLEAN NOT NULL) RETURNS TY$POINTER
    EXTERNAL NAME 'lkjson!ParseText'
    ENGINE UDR;

  FUNCTION ParseString(
      /* -- */ String VARCHAR(32765) CHARACTER SET NONE,
      -- utf8 String VARCHAR(8191) CHARACTER SET UTF8,
      Conv BOOLEAN NOT NULL 
    ) RETURNS TY$POINTER
    EXTERNAL NAME 'lkjson!ParseString'
    ENGINE UDR;

  FUNCTION GenerateText(Obj TY$POINTER, Conv BOOLEAN NOT NULL) RETURNS BLOB SUB_TYPE TEXT
    EXTERNAL NAME 'lkjson!GenerateText'
    ENGINE UDR;

  FUNCTION GenerateString(Obj TY$POINTER, Conv BOOLEAN NOT NULL)
    /* -- */ RETURNS VARCHAR(32765) CHARACTER SET NONE
    -- utf8 RETURNS VARCHAR(8191) CHARACTER SET UTF8
    EXTERNAL NAME 'lkjson!GenerateString'
    ENGINE UDR;

  FUNCTION ReadableText(Obj TY$POINTER, Level INTEGER NOT NULL, Conv BOOLEAN NOT NULL)
    RETURNS BLOB SUB_TYPE TEXT
    EXTERNAL NAME 'lkjson!ReadableText'
    ENGINE UDR;

END^


RECREATE PACKAGE BODY JS$LIST
AS
BEGIN

  FUNCTION Field(
      Self TY$POINTER,
      /* -- */ Name VARCHAR(256) CHARACTER SET NONE NOT NULL
      -- utf8 Name VARCHAR(64) CHARACTER SET UTF8 NOT NULL
    ) RETURNS TY$POINTER
  AS
  BEGIN
    RETURN js$custList.Field(Self, Name);
  END

  FUNCTION IndexOfObject(Self TY$POINTER, Obj TY$POINTER NOT NULL) RETURNS INTEGER
    EXTERNAL NAME 'lkjson!ListIndexOfObject'
    ENGINE UDR;

  FUNCTION Count_(Self TY$POINTER) RETURNS INTEGER
  AS
  BEGIN
    RETURN js$custList.Count_(Self);
  END

  FUNCTION Parent(Self TY$POINTER) RETURNS TY$POINTER
  AS
  BEGIN
    RETURN js$custList.Parent(Self);
  END

  FUNCTION Child(Self TY$POINTER, Idx INTEGER NOT NULL, Obj TY$POINTER) RETURNS TY$POINTER
  AS
  BEGIN
    RETURN js$custList.Child(Self, Idx, Obj);
  END

  FUNCTION Add_(Self TY$POINTER, Obj TY$POINTER NOT NULL) RETURNS INTEGER
    EXTERNAL NAME 'lkjson!ListAdd'
    ENGINE UDR;

  FUNCTION AddBoolean(Self TY$POINTER, Bool BOOLEAN) RETURNS INTEGER
    EXTERNAL NAME 'lkjson!ListAddBoolean'
    ENGINE UDR;

  FUNCTION AddDouble(Self TY$POINTER, Dbl DOUBLE PRECISION) RETURNS INTEGER
    EXTERNAL NAME 'lkjson!ListAddDouble'
    ENGINE UDR;

  FUNCTION AddInteger(Self TY$POINTER, Int_ INTEGER) RETURNS INTEGER
    EXTERNAL NAME 'lkjson!ListAddInteger'
    ENGINE UDR;

  FUNCTION AddString(
      Self TY$POINTER,
      /* -- */ Str VARCHAR(32765) CHARACTER SET NONE
      -- utf8 Str VARCHAR(8191) CHARACTER SET UTF8
    ) RETURNS INTEGER
    EXTERNAL NAME 'lkjson!ListAddString'
    ENGINE UDR;

  FUNCTION AddWideString(Self TY$POINTER, WStr BLOB SUB_TYPE TEXT) RETURNS INTEGER
    EXTERNAL NAME 'lkjson!ListAddWideString'
    ENGINE UDR;

  FUNCTION Delete_(Self TY$POINTER, Idx INTEGER NOT NULL) RETURNS SMALLINT
    EXTERNAL NAME 'lkjson!ListDelete'
    ENGINE UDR;

  PROCEDURE ForEach(
      Self TY$POINTER
    ) RETURNS (
      Idx INTEGER,
      /* -- */ Name VARCHAR(256) CHARACTER SET NONE,
      -- utf8 Name VARCHAR(256) CHARACTER SET UTF8,
      Obj TY$POINTER
    )
  AS
  BEGIN
    FOR
      SELECT Idx, Name, Obj FROM js$custList.ForEach(:Self)
        INTO :Idx, :Name, :Obj
    DO
      SUSPEND;
  END

  FUNCTION Generate(Self TY$POINTER) RETURNS TY$POINTER
    EXTERNAL NAME 'lkjson!ListGenerate'
    ENGINE UDR;

  FUNCTION SelfType(Self TY$POINTER) RETURNS SMALLINT
    EXTERNAL NAME 'lkjson!ListSelfType'
    ENGINE UDR;

  FUNCTION SelfTypeName(Self TY$POINTER)
    /* -- */ RETURNS VARCHAR(64) CHARACTER SET NONE
    -- utf8 RETURNS VARCHAR(16) CHARACTER SET UTF8
    EXTERNAL NAME 'lkjson!ListSelfTypeName'
    ENGINE UDR;

END^


RECREATE PACKAGE BODY JS$METH
AS
BEGIN

  FUNCTION Parent(Self TY$POINTER) RETURNS TY$POINTER
  AS
  BEGIN
    RETURN js$Base.Parent(Self);
  END

  FUNCTION MethodObjValue(Self TY$POINTER) RETURNS TY$POINTER
    EXTERNAL NAME 'lkjson!ObjectMethodObjValue'
    ENGINE UDR;

  FUNCTION MethodName(
      Self TY$POINTER,
      /* -- */ Name VARCHAR(256) CHARACTER SET NONE
      -- utf8 Name VARCHAR(64) CHARACTER SET UTF8
    /* -- */ ) RETURNS VARCHAR(256) CHARACTER SET NONE
    -- utf8) RETURNS VARCHAR(64) CHARACTER SET UTF8
    EXTERNAL NAME 'lkjson!ObjectMethodName'
    ENGINE UDR;

  FUNCTION MethodGenerate(
      Self TY$POINTER,
      /* -- */ Name VARCHAR(256) CHARACTER SET NONE NOT NULL,
      -- utf8 Name VARCHAR(64) CHARACTER SET UTF8 NOT NULL,
      Obj TY$POINTER NOT NULL
    ) RETURNS TY$POINTER
    EXTERNAL NAME 'lkjson!ObjectMethodGenerate'
    ENGINE UDR;

END^


RECREATE PACKAGE BODY JS$NULL
AS
BEGIN

  FUNCTION Parent(Self TY$POINTER) RETURNS TY$POINTER
  AS
  BEGIN
    RETURN js$Base.Parent(Self);
  END

  FUNCTION Value_(Self TY$POINTER) RETURNS SMALLINT
    EXTERNAL NAME 'lkjson!NullValue'
    ENGINE UDR;

  FUNCTION Generate(Self TY$POINTER) RETURNS TY$POINTER
    EXTERNAL NAME 'lkjson!NullGenerate'
    ENGINE UDR;

  FUNCTION SelfType(Self TY$POINTER) RETURNS SMALLINT
    EXTERNAL NAME 'lkjson!NullSelfType'
    ENGINE UDR;

  FUNCTION SelfTypeName(Self TY$POINTER)
    /* -- */ RETURNS VARCHAR(64) CHARACTER SET NONE
    -- utf8 RETURNS VARCHAR(16) CHARACTER SET UTF8
    EXTERNAL NAME 'lkjson!NullSelfTypeName'
    ENGINE UDR;

END^


RECREATE PACKAGE BODY JS$NUM
AS
BEGIN

  FUNCTION Parent(Self TY$POINTER) RETURNS TY$POINTER
  AS
  BEGIN
    RETURN js$Base.Parent(Self);
  END

  FUNCTION Value_(Self TY$POINTER, Num DOUBLE PRECISION) RETURNS DOUBLE PRECISION
    EXTERNAL NAME 'lkjson!NumberValue'
    ENGINE UDR;

  FUNCTION Generate(Self TY$POINTER, Num DOUBLE PRECISION NOT NULL) RETURNS TY$POINTER
    EXTERNAL NAME 'lkjson!NumberGenerate'
    ENGINE UDR;

  FUNCTION SelfType(Self TY$POINTER) RETURNS SMALLINT
    EXTERNAL NAME 'lkjson!NumberSelfType'
    ENGINE UDR;

  FUNCTION SelfTypeName(Self TY$POINTER )
    /* -- */ RETURNS VARCHAR(64) CHARACTER SET NONE
    -- utf8 RETURNS VARCHAR(16) CHARACTER SET UTF8
    EXTERNAL NAME 'lkjson!NumberSelfTypeName'
    ENGINE UDR;

END^


RECREATE PACKAGE BODY JS$OBJ
AS
BEGIN

  FUNCTION New_(UseHash BOOLEAN NOT NULL) RETURNS TY$POINTER
    EXTERNAL NAME 'lkjson!ObjectNew'
    ENGINE UDR;

  FUNCTION Dispose(Self TY$POINTER) RETURNS SMALLINT
    EXTERNAL NAME 'lkjson!ObjectDispose'
    ENGINE UDR;

  FUNCTION Field(
      Self TY$POINTER,
      /* -- */ Name VARCHAR(256) CHARACTER SET NONE NOT NULL,
      -- utf8 Name VARCHAR(64) CHARACTER SET UTF8 NOT NULL,
      Obj TY$POINTER
    ) RETURNS TY$POINTER
    EXTERNAL NAME 'lkjson!ObjectField'
    ENGINE UDR;

  FUNCTION FieldByIndex(Self TY$POINTER, Idx INTEGER NOT NULL, Obj TY$POINTER) RETURNS TY$POINTER
    EXTERNAL NAME 'lkjson!ObjectFieldByIndex'
    ENGINE UDR;

  FUNCTION NameOf(Self TY$POINTER, Idx INTEGER NOT NULL)
    /*  */ RETURNS VARCHAR(256) CHARACTER SET NONE NOT NULL
    -- utf8 RETURNS VARCHAR(64) CHARACTER SET UTF8 NOT NULL
    EXTERNAL NAME 'lkjson!ObjectNameOf'
    ENGINE UDR;

  FUNCTION IndexOfName(
      Self TY$POINTER,
      /* -- */ Name VARCHAR(256) CHARACTER SET NONE NOT NULL
      -- utf8 Name VARCHAR(64) CHARACTER SET UTF8 NOT NULL
    ) RETURNS INTEGER
    EXTERNAL NAME 'lkjson!ObjectIndexOfName'
    ENGINE UDR;

  FUNCTION IndexOfObject(Self TY$POINTER, Obj TY$POINTER NOT NULL) RETURNS INTEGER
    EXTERNAL NAME 'lkjson!ObjectIndexOfObject'
    ENGINE UDR;

  FUNCTION Count_(Self TY$POINTER) RETURNS INTEGER
  AS
  BEGIN
    RETURN js$custList.Count_(Self);
  END

  FUNCTION Parent(Self TY$POINTER) RETURNS TY$POINTER
  AS
  BEGIN
    RETURN js$custList.Parent(Self);
  END

  FUNCTION Child(Self TY$POINTER, Idx INTEGER NOT NULL, Obj TY$POINTER) RETURNS TY$POINTER
  AS
  BEGIN
    RETURN js$custList.Child(Self, Idx, Obj);
  END

  FUNCTION Add_(
      Self TY$POINTER,
      /* -- */ Name VARCHAR(256) CHARACTER SET NONE NOT NULL,
      -- utf8 Name VARCHAR(64) CHARACTER SET UTF8 NOT NULL,
      Obj TY$POINTER NOT NULL
    ) RETURNS INTEGER
    EXTERNAL NAME 'lkjson!ObjectAdd'
    ENGINE UDR;

  FUNCTION AddBoolean(
      Self TY$POINTER,
      /* -- */ Name VARCHAR(256) CHARACTER SET NONE NOT NULL,
      -- utf8 Name VARCHAR(64) CHARACTER SET UTF8 NOT NULL,
      Bool BOOLEAN
    ) RETURNS INTEGER
    EXTERNAL NAME 'lkjson!ObjectAddBoolean'
    ENGINE UDR;

  FUNCTION AddDouble(
      Self TY$POINTER,
      /* -- */ Name VARCHAR(256) CHARACTER SET NONE NOT NULL,
      -- utf8 Name VARCHAR(64) CHARACTER SET UTF8 NOT NULL,
      Dbl DOUBLE PRECISION
    ) RETURNS INTEGER
    EXTERNAL NAME 'lkjson!ObjectAddDouble'
    ENGINE UDR;

  FUNCTION AddInteger(
      Self TY$POINTER,
      /* -- */ Name VARCHAR(256) CHARACTER SET NONE NOT NULL,
      -- utf8 Name VARCHAR(64) CHARACTER SET UTF8 NOT NULL,
      Int_ INTEGER
    ) RETURNS INTEGER
    EXTERNAL NAME 'lkjson!ObjectAddInteger'
    ENGINE UDR;

  FUNCTION AddString(
      Self TY$POINTER,
      /* -- */ Name VARCHAR(256) CHARACTER SET NONE NOT NULL,
      -- utf8 Name VARCHAR(64) CHARACTER SET UTF8 NOT NULL,
      /*  */ Str VARCHAR(32765) CHARACTER SET NONE
      -- utf8 Str VARCHAR(8191) CHARACTER SET UTF8
    ) RETURNS INTEGER
    EXTERNAL NAME 'lkjson!ObjectAddString'
    ENGINE UDR;

  FUNCTION AddWideString(
      Self TY$POINTER,
      /* -- */ Name VARCHAR(256) CHARACTER SET NONE NOT NULL,
      -- utf8 Name VARCHAR(64) CHARACTER SET UTF8 NOT NULL,
      WStr BLOB SUB_TYPE TEXT
    ) RETURNS INTEGER
    EXTERNAL NAME 'lkjson!ObjectAddWideString'
    ENGINE UDR;

  FUNCTION GetBoolean(Self TY$POINTER, Idx INTEGER NOT NULL) RETURNS BOOLEAN
    EXTERNAL NAME 'lkjson!ObjectGetBoolean'
    ENGINE UDR;

  FUNCTION GetDouble(Self TY$POINTER, Idx INTEGER NOT NULL) RETURNS DOUBLE PRECISION
    EXTERNAL NAME 'lkjson!ObjectGetDouble'
    ENGINE UDR;

  FUNCTION GetInteger(Self TY$POINTER, Idx INTEGER NOT NULL) RETURNS INTEGER
    EXTERNAL NAME 'lkjson!ObjectGetInteger'
    ENGINE UDR;

  FUNCTION GetString(Self TY$POINTER, Idx INTEGER NOT NULL) RETURNS VARCHAR(32765)
    EXTERNAL NAME 'lkjson!ObjectGetString'
    ENGINE UDR;

  FUNCTION GetWideString(Self TY$POINTER, Idx INTEGER NOT NULL) RETURNS BLOB SUB_TYPE TEXT
    EXTERNAL NAME 'lkjson!ObjectGetWideString'
    ENGINE UDR;

  FUNCTION GetBooleanByName(
      Self TY$POINTER,
      /* -- */ Name VARCHAR(256) CHARACTER SET NONE NOT NULL
      -- utf8 Name VARCHAR(64) CHARACTER SET UTF8 NOT NULL
    ) RETURNS BOOLEAN
    EXTERNAL NAME 'lkjson!ObjectGetBooleanByName'
    ENGINE UDR;

  FUNCTION GetDoubleByName(
      Self TY$POINTER,
      /* -- */ Name VARCHAR(256) CHARACTER SET NONE NOT NULL
      -- utf8 Name VARCHAR(64) CHARACTER SET UTF8 NOT NULL
    ) RETURNS DOUBLE PRECISION
    EXTERNAL NAME 'lkjson!ObjectGetDoubleByName'
    ENGINE UDR;

  FUNCTION GetIntegerByName(
      Self TY$POINTER,
      /* -- */ Name VARCHAR(256) CHARACTER SET NONE NOT NULL
      -- utf8 Name VARCHAR(64) CHARACTER SET UTF8 NOT NULL
    ) RETURNS INTEGER
    EXTERNAL NAME 'lkjson!ObjectGetIntegerByName'
    ENGINE UDR;

  FUNCTION GetStringByName(
      Self TY$POINTER,
      /* -- */ Name VARCHAR(256) CHARACTER SET NONE NOT NULL
      -- utf8 Name VARCHAR(64) CHARACTER SET UTF8 NOT NULL
    /*  */ ) RETURNS VARCHAR(32765) CHARACTER SET NONE
    -- utf8 ) RETURNS VARCHAR(8191) CHARACTER SET UTF8
    EXTERNAL NAME 'lkjson!ObjectGetStringByName'
    ENGINE UDR;

  FUNCTION GetWideStringByName(
      Self TY$POINTER,
      /* -- */ Name VARCHAR(256) CHARACTER SET NONE NOT NULL
      -- utf8 Name VARCHAR(64) CHARACTER SET UTF8 NOT NULL
    ) RETURNS BLOB SUB_TYPE TEXT
    EXTERNAL NAME 'lkjson!ObjectGetWideStringByName'
    ENGINE UDR;
    
  FUNCTION Delete_(Self TY$POINTER, Idx INTEGER NOT NULL) RETURNS SMALLINT
    EXTERNAL NAME 'lkjson!ObjectDelete'
    ENGINE UDR;

  PROCEDURE ForEach(
      Self TY$POINTER
    ) RETURNS (
      Idx INTEGER,
      /* -- */ Name VARCHAR(256) CHARACTER SET NONE,
      -- utf8 Name VARCHAR(64) CHARACTER SET UTF8,
      Obj TY$POINTER
    )
  AS
    DECLARE Count_ INTEGER;
    DECLARE ObjMethod TY$POINTER;
  BEGIN
    Idx = 0;
    Count_ = Count_(Self);
    WHILE (Idx < Count_) DO
    BEGIN
      ObjMethod = Child(Self, Idx);
      Name = js$Meth.MethodName(ObjMethod);
      Obj = js$Meth.MethodObjValue(ObjMethod);
      SUSPEND;
      Idx = Idx + 1;
    END 
  END

  FUNCTION Generate(Self TY$POINTER, UseHash BOOLEAN NOT NULL) RETURNS TY$POINTER
    EXTERNAL NAME 'lkjson!ObjectGenerate'
    ENGINE UDR;

  FUNCTION SelfType(Self TY$POINTER) RETURNS SMALLINT
    EXTERNAL NAME 'lkjson!ObjectSelfType'
    ENGINE UDR;

  FUNCTION SelfTypeName(Self TY$POINTER)
    /* -- */ RETURNS VARCHAR(64) CHARACTER SET NONE
    -- utf8 RETURNS VARCHAR(16) CHARACTER SET UTF8
    EXTERNAL NAME 'lkjson!ObjectSelfTypeName'
    ENGINE UDR;

END^


RECREATE PACKAGE BODY JS$PTR
AS
BEGIN

  FUNCTION New_(
      UsePtr CHAR(3) CHARACTER SET NONE NOT NULL,
      UseHash BOOLEAN NOT NULL
    ) RETURNS TY$POINTER
  AS
    DECLARE js TY$POINTER;
  BEGIN
    js = NULL;
    IF (UPPER(UsePtr) = 'TRA') THEN
    BEGIN
      IF (EXISTS (
            SELECT *
              FROM rdb$triggers t
              WHERE t.rdb$trigger_name = 'JS$PTR_TRA_COMMIT' AND
                    t.rdb$trigger_inactive = 0 AND t.rdb$system_flag = 0
              )
          AND
          EXISTS (
            SELECT *
              FROM rdb$triggers t
              WHERE t.rdb$trigger_name = 'JS$PTR_TRA_ROLLBACK' AND
                    t.rdb$trigger_inactive = 0 AND t.rdb$system_flag = 0
              )
         ) THEN
      BEGIN
        js = CAST(RDB$GET_CONTEXT('USER_TRANSACTION', 'JS$PTR.TRANSACTION') AS TY$POINTER);
        IF (js IS NULL) THEN
        BEGIN
          js = js$Obj.New_(TRUE);
          RDB$SET_CONTEXT('USER_TRANSACTION', 'JS$PTR.TRANSACTION', js);
        END
      END
    END ELSE
    IF (UPPER(UsePtr) = 'ATT') THEN
    BEGIN
      IF (EXISTS (
            SELECT *
              FROM rdb$triggers t
              WHERE t.rdb$trigger_name = 'JS$PTR_ATT_DISCONNECT'
                    AND t.rdb$trigger_inactive = 0 AND t.rdb$system_flag = 0
              )
         ) THEN
      BEGIN
        js = CAST(RDB$GET_CONTEXT('USER_SESSION', 'JS$PTR.ATTACHMENT') AS TY$POINTER);
        IF (js IS NULL) THEN
        BEGIN
          js = js$Obj.New_(TRUE);
          RDB$SET_CONTEXT('USER_SESSION', 'JS$PTR.ATTACHMENT', js);
        END
      END
    END
    RETURN js;
  END

  FUNCTION Dispose(UsePtr CHAR(3) CHARACTER SET NONE NOT NULL) RETURNS SMALLINT
  AS
    DECLARE js TY$POINTER;
  BEGIN
    IF (UPPER(UsePtr) = 'TRA') THEN js = tra(); ELSE
    IF (UPPER(UsePtr) = 'ATT') THEN js = att(); ELSE
      js = NULL;
    IF (js IS NOT NULL)  THEN
    BEGIN
      IF (UPPER(UsePtr) = 'TRA') THEN RDB$SET_CONTEXT('USER_TRANSACTION', 'JS$PTR.TRANSACTION', NULL);
      IF (UPPER(UsePtr) = 'ATT') THEN RDB$SET_CONTEXT('USER_SESSION', 'JS$PTR.ATTACHMENT', NULL);
      RETURN js$Obj.Dispose(js);
    END
    ELSE
      RETURN NULL;
  END

  FUNCTION Tra RETURNS TY$POINTER
  AS
  BEGIN
    RETURN
      CAST(RDB$GET_CONTEXT('USER_TRANSACTION', 'JS$PTR.TRANSACTION') AS TY$POINTER);
  END

  FUNCTION Att RETURNS TY$POINTER
  AS
  BEGIN
    RETURN
      CAST(RDB$GET_CONTEXT('USER_SESSION', 'JS$PTR.ATTACHMENT') AS TY$POINTER);
  END

  FUNCTION isNull(jsPtr TY$POINTER) RETURNS BOOLEAN
  AS
    DECLARE nullPtr TY$POINTER = x'0000000000000000';
  BEGIN
    RETURN
      CASE
         WHEN jsPtr IS NULL OR jsPtr = nullPtr THEN TRUE
           ELSE FALSE
      END;
  END

END^


RECREATE PACKAGE BODY JS$STR
AS
BEGIN

  FUNCTION Parent(Self TY$POINTER) RETURNS TY$POINTER
  AS
  BEGIN
    RETURN js$Base.Parent(Self);
  END

  FUNCTION Value_(
      Self TY$POINTER,
      /*  */ Str VARCHAR(32765) CHARACTER SET NONE
      -- utf8 Str VARCHAR(8191) CHARACTER SET UTF8
    /* -- */ ) RETURNS VARCHAR(32765) CHARACTER SET NONE
    -- utf8 ) RETURNS VARCHAR(8191) CHARACTER SET UTF8
    EXTERNAL NAME 'lkjson!StringValue'
    ENGINE UDR;

  FUNCTION WideValue_(Self TY$POINTER, WStr BLOB SUB_TYPE TEXT) RETURNS BLOB SUB_TYPE TEXT
    EXTERNAL NAME 'lkjson!StringWideValue'
    ENGINE UDR;

  FUNCTION Generate(
      Self TY$POINTER,
      /*  */ Str VARCHAR(32765) CHARACTER SET NONE NOT NULL
      -- utf8 Str VARCHAR(8191) CHARACTER SET UTF8 NOT NULL
    ) RETURNS TY$POINTER
    EXTERNAL NAME 'lkjson!StringGenerate'
    ENGINE UDR;

  FUNCTION WideGenerate(Self TY$POINTER, WStr BLOB SUB_TYPE TEXT) RETURNS TY$POINTER
    EXTERNAL NAME 'lkjson!StringWideGenerate'
    ENGINE UDR;

  FUNCTION SelfType(Self TY$POINTER) RETURNS SMALLINT
    EXTERNAL NAME 'lkjson!StringSelfType'
    ENGINE UDR;

  FUNCTION SelfTypeName(Self TY$POINTER)
    /* -- */ RETURNS VARCHAR(64) CHARACTER SET NONE
    -- utf8 RETURNS VARCHAR(16) CHARACTER SET UTF8
    EXTERNAL NAME 'lkjson!StringSelfTypeName'
    ENGINE UDR;

END^



SET TERM ; ^



/******************************************************************************/
/***                               Privileges                               ***/
/******************************************************************************/



/******************************************************************************/
/***                             DDL privileges                             ***/
/******************************************************************************/

