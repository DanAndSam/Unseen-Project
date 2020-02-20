using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class PlayerController : MonoBehaviour
{
    private float comboBuff = 0;
    private Animator animator;
    private int tempAnimIndex = 0;

    public int animationIndex = 1;
    public bool canAddition = true;

    private void Awake()
    {
        animator = GetComponentInChildren<Animator>();
        CombatManager.Instance.SetPlayerReference(this);
    }

    private void Update()
    {
        
    }

    public void Attack()
    {
        if (animator != null)
        {
            //if (canAddition)
            {                
                if (animationIndex > 1)
                {
                    if (CombatManager.Instance.ReturnIsReticulisTime())
                    {
                        StartCoroutine(TestReticule(animationIndex));
                        tempAnimIndex = animationIndex;
                        animationIndex++;
                        CombatManager.Instance.SuccessfulAddition();
                        if (animationIndex > 5)
                        {
                            animationIndex = 1;                            
                        }
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
                    tempAnimIndex = animationIndex;
                    animationIndex++;
                }
            }            
        }
    }

    public void ResetAnimationIndex()
    {
        animationIndex = 1;
    }

    public IEnumerator TestReticule(int animIndex)
    {
        animator.SetTrigger("Step" + animIndex.ToString());
        yield return new WaitForEndOfFrame();
        Debug.Log("Launching");

        if (tempAnimIndex < 5)
            CombatManager.Instance.LaunchReticule();
        yield return new WaitForSeconds(ReturnCurrentClipLength());
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
