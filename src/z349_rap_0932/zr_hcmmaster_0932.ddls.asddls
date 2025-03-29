@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Root - HCM Master'
@Metadata.ignorePropagatedAnnotations: true
define root view entity ZR_HCMMASTER_0932
  as select from zhcm_master_0932 as HCMMaster
{

  key e_number,
      e_name,
      e_department,
      status,
      job_title,
      start_date,
      end_date,
      email,
      m_number,
      m_name,
      m_department,
      crea_date_time,
      crea_uname,
      lchg_date_time,
      lchg_uname
}
