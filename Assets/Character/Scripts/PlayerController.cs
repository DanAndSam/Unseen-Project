using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class PlayerController : MonoBehaviour
{
    private float comboBuff = 0;
    private Animator animator;
    private bool canAddition = false;

    public int animationIndex = 1;

    private void Awake()
    {
        animator = GetComponentInChildren<Animator>();
        CombatManager.Instance.SetPlayerReference(this);
    }

    private void Update()
    {
        Debug.Log(CombatManager.Instance.ReturnIsReticulisTime());
        //Debug.Log(animator.GetCurrentAnimatorStateInfo(0).normalizedTime);
    }

    public void Attack()
    {
        if (animator != null)
        {
            if (canAddition)
            {
                canAddition = false;
                if (animationIndex > 1)
                {                    
                    if (CombatManager.Instance.ReturnIsReticulisTime())
                    {
                        animationIndex++;
                        StartCoroutine(TestReticule(animationIndex));
                    }
                    else
                    {
                        animationIndex = 1;
                        animator.SetTrigger("Fail");
                        return;
                    }
                }
                else
                {
                    StartCoroutine(TestReticule(animationIndex));
                    animationIndex++;
                }
            }
        }
    }

    public IEnumerator TestReticule(int animIndex)
    {
        //Just for testing purposes
        animator.SetTrigger("Step"+ animIndex.ToString());
        yield return new WaitForEndOfFrame();
        CombatManager.Instance.LaunchReticule();        
        yield return new WaitForSeconds(ReturnCurrentClipLength());        
        /*animator.SetTrigger("Step2");
        yield return new WaitForEndOfFrame();
        CombatManager.Instance.LaunchReticule();
        

        yield return new WaitForSeconds(ReturnCurrentClipLength());

        animator.SetTrigger("Step3");
        yield return new WaitForEndOfFrame();
        CombatManager.Instance.LaunchReticule();
        

        yield return new WaitForSeconds(ReturnCurrentClipLength() - 0.11f);

        animator.SetTrigger("Step4");
        yield return new WaitForEndOfFrame();
        CombatManager.Instance.LaunchReticule();
        
        yield return new WaitForSeconds(ReturnCurrentClipLength());*/
    }

    public float ReturnCurrentClipLength()
    {
        Debug.Log(animator.GetCurrentAnimatorStateInfo(0).length);
        return animator.GetCurrentAnimatorStateInfo(0).length;
    }

    private bool ReturnAdditionSuccess()
    {
        bool isSuccess = false;

        Debug.Log(animator.GetCurrentAnimatorStateInfo(0).length - animator.GetCurrentAnimatorStateInfo(0).normalizedTime);

        if ((animator.GetCurrentAnimatorStateInfo(0).length - animator.GetCurrentAnimatorStateInfo(0).normalizedTime) < 0.23f + comboBuff && (animator.GetCurrentAnimatorStateInfo(0).length - animator.GetCurrentAnimatorStateInfo(0).normalizedTime) > 0)
            isSuccess = true;
        else
            animationIndex = 1;

        return isSuccess;
    }
}
