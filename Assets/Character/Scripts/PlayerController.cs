using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class PlayerController : MonoBehaviour
{
    private Animator animator;

    private void Awake()
    {
        animator = GetComponentInChildren<Animator>();
        CombatManager.Instance.SetPlayerReference(this);
    }

    public void Attack()
    {
        if (animator != null)
        {
            StartCoroutine(TestReticule());

            /*CombatManager.Instance.LaunchReticule();
            animator.SetTrigger("Step1");           */
        }
    }

    public IEnumerator TestReticule()
    {
        CombatManager.Instance.LaunchReticule();
        animator.SetTrigger("Step1");

        yield return new WaitForSeconds(animator.GetCurrentAnimatorStateInfo(0).length + 0.01f);

        CombatManager.Instance.LaunchReticule();
        animator.SetTrigger("Step2");

        yield return new WaitForSeconds(animator.GetCurrentAnimatorStateInfo(0).length + 0.01f);

        CombatManager.Instance.LaunchReticule();
        animator.SetTrigger("Step3");

        yield return new WaitForSeconds(animator.GetCurrentAnimatorStateInfo(0).length + 0.01f);

        animator.SetTrigger("Step4");
    }

    public float ReturnCurrentClipLength()
    {
        return animator.GetCurrentAnimatorStateInfo(0).length;
    }
}
