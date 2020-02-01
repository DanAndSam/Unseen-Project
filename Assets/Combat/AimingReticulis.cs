using System.Collections;
using System.Collections.Generic;
using UnityEngine.UI;
using DG.Tweening;
using UnityEngine;

public class AimingReticulis : MonoBehaviour
{
    public GameObject reticulis;
    public GameObject reticulisTarget;

    private bool canLaunchRiticule = true;
    private Vector3 reticulisStartRot = new Vector3();
    private Vector3 reticulisStartScale = new Vector3();
    private Color reticulisStartColor = new Color();

    private void Start()
    {
        reticulisStartRot = reticulis.transform.eulerAngles;
        reticulisStartScale = reticulis.transform.localScale;
        reticulisStartColor = reticulis.GetComponent<Image>().color;
    }

    public void Launch()
    {
        if(canLaunchRiticule)
            StartCoroutine(StartReticulis());
    }

    public void ResetReticulis()
    {
        reticulis.transform.eulerAngles = reticulisStartRot;
        reticulis.transform.localScale = reticulisStartScale;
        reticulis.SetActive(false);
        reticulisTarget.SetActive(false);
        reticulis.GetComponent<Image>().color = reticulisStartColor;
        canLaunchRiticule = true;
    }

    private IEnumerator StartReticulis()
    {
        canLaunchRiticule = false;
        reticulis.SetActive(true);
        reticulisTarget.SetActive(true);

        reticulis.transform.DORotate(reticulisTarget.transform.eulerAngles,0.5f).SetEase(Ease.Linear).SetLoops(7, LoopType.Incremental);
        reticulis.transform.DOScale(reticulisTarget.transform.localScale, 3.5f);

        yield return new WaitForSeconds(3.5f);

        reticulis.GetComponent<Image>().DOFade(0, 1.5f);
        reticulisTarget.GetComponent<Image>().DOFade(0, 1.5f);
        yield return new WaitForSeconds(1.5f);
        ResetReticulis();
    }
}
