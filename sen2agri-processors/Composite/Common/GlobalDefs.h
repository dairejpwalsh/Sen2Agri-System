#ifndef GLOBALDEFS_H
#define GLOBALDEFS_H

#define DEFAULT_QUANTIFICATION_VALUE   1000
#define NO_DATA_VALUE               -10000

#define WEIGHT_NO_DATA_VALUE        -10000

#define EPSILON         0.0001f
#define NO_DATA_EPSILON EPSILON

typedef enum {IMG_FLG_NO_DATA=0, IMG_FLG_CLOUD=1, IMG_FLG_SNOW=2, IMG_FLG_WATER=3, IMG_FLG_LAND=4, IMG_FLG_CLOUD_SHADOW=5, IMG_FLG_SATURATION=6} FlagType;


template<typename T>
struct HasSizeMethod
{
    template<typename U, unsigned int (U::*)() const> struct SFINAE {};
    template<typename U> static char Test(SFINAE<U, &U::Size>*);
    template<typename U> static int Test(...);
    static const bool Has = sizeof(Test<T>(0)) == sizeof(char);
};

// Translates the SHORT reflectances in the input image into FLOAT, taking into account
// the quantification value
template< class TInput, class TOutput>
class ShortToFloatTranslationFunctor
{
public:
    ShortToFloatTranslationFunctor() {}
    ~ShortToFloatTranslationFunctor() {}
    void Initialize(float fQuantificationVal) {
        m_fQuantifVal = fQuantificationVal;
  }

  bool operator!=( const ShortToFloatTranslationFunctor &a) const
  {
      return (this->m_fQuantifVal != a.m_fQuantifVal);
  }
  bool operator==( const ShortToFloatTranslationFunctor & other ) const
  {
    return !(*this != other);
  }
  inline TOutput operator()( const TInput & A ) const
  {
      TOutput ret(A.Size());
      for(int i = 0; i<A.Size(); i++) {
           if(fabs(A[i] - NO_DATA_VALUE) < 0.00001) {
               ret[i] = NO_DATA_VALUE;
           } else {
                ret[i] = static_cast< float >(static_cast< float >(A[i]))/m_fQuantifVal;
           }
      }

      return ret;
  }
private:
  int m_fQuantifVal;
};

// Translates the FLOAT reflectances in the input image into SHORT, taking into account
// the quantification value
template< class TInput, class TOutput>
class FloatToShortTranslationFunctor
{
public:
    FloatToShortTranslationFunctor() {}
    ~FloatToShortTranslationFunctor() {}
    void Initialize(float fQuantificationVal, float fNoDataVal = 0) {
        m_fQuantifVal = fQuantificationVal;
        m_fNoDataVal = fNoDataVal;
  }

  bool operator!=( const FloatToShortTranslationFunctor &a) const
  {
      return ((this->m_fQuantifVal != a.m_fQuantifVal) || (this->m_fNoDataVal != a.m_fNoDataVal));
  }
  bool operator==( const FloatToShortTranslationFunctor & other ) const
  {
    return !(*this != other);
  }
  inline TOutput operator()( const TInput & A )
  {
      return HandleMultiSizeInput(A,
             std::integral_constant<bool, HasSizeMethod<TInput>::Has>());
  }

  inline TOutput HandleMultiSizeInput(const TInput & A, std::true_type)
  {
      TOutput ret(A.Size());
      for(int i = 0; i<A.Size(); i++) {
           if(fabs(A[i] - m_fNoDataVal) < NO_DATA_EPSILON) {
               ret[i] = m_fNoDataVal;
           } else {
                ret[i] = static_cast< unsigned short >(A[i] * m_fQuantifVal);
           }
      }

      return ret;
  }
  inline TOutput HandleMultiSizeInput(const TInput & A, std::false_type)
  {
      TOutput ret;
      if(fabs(A - m_fNoDataVal) < NO_DATA_EPSILON) {
        ret = m_fNoDataVal;
      } else {
        ret = static_cast< unsigned short >(A * m_fQuantifVal);
      }

      return ret;
  }
private:
  int m_fQuantifVal;
  int m_fNoDataVal;
};


#endif //GLOBALDEFS_H
