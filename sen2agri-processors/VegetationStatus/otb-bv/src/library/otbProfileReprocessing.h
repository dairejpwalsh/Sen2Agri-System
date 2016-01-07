/*=========================================================================
  Program:   otb-bv
  Language:  C++

  Copyright (c) CESBIO. All rights reserved.

  See otb-bv-copyright.txt for details.

  This software is distributed WITHOUT ANY WARRANTY; without even
  the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR
  PURPOSE.  See the above copyright notices for more information.

=========================================================================*/
#ifndef __OTBBVPROFREPR_H
#define __OTBBVPROFREPR_H

#include <vector>
#include <phenoFunctions.h>

using PrecisionType = double;
using VectorType = std::vector<PrecisionType>;
constexpr PrecisionType not_processed_value{0};
constexpr PrecisionType processed_value{1};

#define NO_DATA_VALUE   -10000.0f
#define NO_DATA_EPSILON 0.0001f

namespace otb
{
template <typename T>
inline 
T compute_weight(T delta, T err)
{
  T one{1};
  return (one/(one+delta)+one/(one+err));
}

bool IsNoDataValue(float fValue)
{
    return (fValue < NO_DATA_EPSILON);
    //return fabs(fValue - NO_DATA_VALUE) < NO_DATA_EPSILON;
}

std::pair<VectorType, VectorType> 
fit_csdm(const VectorType &dts, const VectorType &ts, const VectorType &ets)
{
  assert(ts.size()==ets.size() && ts.size()==dts.size());
  //auto result = ts;
  //auto result_flag = ts;
  auto result = VectorType(ts.size(), 0);
  auto result_flag = VectorType(ts.size(),not_processed_value);
  // std::vector to vnl_vector
  pheno::VectorType profile_vec(ts.size());
  pheno::VectorType date_vec(dts.size());

  for(size_t i=0; i<ts.size(); i++)
    {
    profile_vec[i] = ts[i];
    date_vec[i] = dts[i];
    }

  // A date is valid if it is not NaN and the mask value == 0.
  auto pred = [=](int e) { return !(std::isnan(profile_vec[e])) &&
                           !IsNoDataValue(profile_vec[e]); };
  auto f_profiles = pheno::filter_profile_fast(profile_vec, date_vec, pred);

  decltype(profile_vec) profile=f_profiles.first;
  decltype(profile_vec) t=f_profiles.second;
  if(profile.size() < 4)
  {
    return std::make_pair(result,result_flag);
  }

  // fit
  auto approximation_result = 
    pheno::normalized_sigmoid::TwoCycleApproximation(profile, t);
  auto princ_cycle = std::get<1>(approximation_result);
  auto x_hat = std::get<0>(princ_cycle);
  auto min_max = std::get<1>(princ_cycle);
  auto A_hat = min_max.second - min_max.first;
  auto B_hat = min_max.first;
  pheno::VectorType p(date_vec.size());
  pheno::normalized_sigmoid::F<pheno::VectorType>()(date_vec, x_hat, p);
  //fill the result vectors
  for(size_t i=0; i<ts.size(); i++)
  {
    if(!IsNoDataValue(profile_vec[i]))
    {
        result[i] = p[i]*A_hat+B_hat;
        result_flag[i] = processed_value;
    }
  }

  return std::make_pair(result,result_flag);
}


std::pair<VectorType, VectorType> 
smooth_time_series_local_window_with_error(const VectorType &dts,
                                           const VectorType &ts,
                                           const VectorType &ets,
                                           size_t bwd_radius = 1,
                                           size_t fwd_radius = 1)
{

  /**
        ------------------------------------
        |                    |             |
       win_first            current       win_last
  */
  assert(ts.size()==ets.size() && ts.size()==dts.size());
  auto result = ts;
  auto result_flag = VectorType(ts.size(),not_processed_value);
  auto ot = result.begin();
  auto otf = result_flag.begin();
  auto eit = ets.begin();
  auto last = ts.end();
  auto win_first = ts.begin();
  auto win_last = ts.begin();
  auto e_win_first = ets.begin();
  auto e_win_last = ets.begin();
  auto dti = dts.begin();
  auto d_win_first = dts.begin();
  auto d_win_last = dts.begin();
//advance iterators
std::advance(ot, bwd_radius);
std::advance(otf, bwd_radius);
std::advance(eit, bwd_radius);
std::advance(dti, bwd_radius);
std::advance(win_last, bwd_radius+fwd_radius);
std::advance(e_win_last, bwd_radius+fwd_radius);
std::advance(d_win_last, bwd_radius+fwd_radius);
while(win_last!=last)
  {
  auto current_d = d_win_first;
  auto current_e = e_win_first;
  auto current_v = win_first;
  auto past_it = d_win_last; ++past_it;

  PrecisionType sum_weights{0.0};
  PrecisionType weighted_value{0.0};
  while(current_d != past_it)
    {
    auto cw = compute_weight(fabs(*current_d-*dti),fabs(*current_e));
    sum_weights += cw;
    weighted_value += (*current_v)*cw;
    ++current_d;
    ++current_e;
    ++current_v;
    }
  *ot = weighted_value/sum_weights;
  *otf = processed_value;
  ++win_first;
  ++win_last;
  ++e_win_first;
  ++e_win_last;
  ++d_win_first;
  ++d_win_last;
  ++ot;
  ++otf;
  ++eit;
  ++dti;
  }
return std::make_pair(result,result_flag);
}

VectorType smooth_time_series(VectorType ts, PrecisionType alpha, 
                              bool online=true)
{
  auto result = ts;
  auto it = ts.begin();
  auto ot = result.begin();
  auto last = ts.end();
  auto prev = *it;
  while(it!=last)
    {
    *ot = (*it)*(1-alpha)+alpha*prev;
    if(online)
      prev = *ot;
    else
      prev = *it;
    ++it;
    ++ot;
    }
  return result;
}

//assumes regular time sampling
VectorType smooth_time_series_n_minus_1(VectorType ts, PrecisionType alpha)
{
  auto result = ts;
  auto ot = result.begin();
  auto last = ts.end();
  auto prev = ts.begin();
  auto next = ts.begin();
  //advance iterators
  ++ot;
  ++next;
  while(next!=last)
    {
    auto lin_interp = ((*prev)+(*next))/2.0;
    *ot = (lin_interp)*(1-alpha)+alpha*(*ot);
    ++prev;
    ++next;
    ++ot;
    }
  return result;
}

}

#endif
